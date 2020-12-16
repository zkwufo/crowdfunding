package com.atzkw.crowd.service.impl;

import com.atzkw.crowd.constant.CrowdConstant;
import com.atzkw.crowd.entity.Admin;
import com.atzkw.crowd.entity.AdminExample;
import com.atzkw.crowd.exception.LoginAcctAlreadyInUseException;
import com.atzkw.crowd.exception.LoginFailedException;
import com.atzkw.crowd.exception.UpdateAcctAlreadyInUseException;
import com.atzkw.crowd.mapper.AdminMapper;
import com.atzkw.crowd.service.api.AdminService;
import com.atzkw.crowd.util.CrowdUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.DuplicateFormatFlagsException;
import java.util.List;
import java.util.Objects;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    private AdminMapper adminMapper;

    public void saveAdmin(Admin admin) {
        String userPwd = admin.getUserPswd();
        userPwd = CrowdUtil.md5(userPwd);
        admin.setUserPswd(userPwd);
        Date date = new Date();
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String createTime = simpleDateFormat.format(date);
        admin.setCreateTime(createTime);
        try {
            adminMapper.insert(admin);
        } catch (Exception e) {
            if (e instanceof DuplicateKeyException) {
                throw new LoginAcctAlreadyInUseException(CrowdConstant.MESSAGE_LOGIN_ACCT_ALREADY_IN_USE);
            }
        }
    }

    public List<Admin> getAll() {
//        给一个空的AdminExample()就是查询全部
        return adminMapper.selectByExample(new AdminExample());
    }

    public Admin getAdminByLoginAcct(String loginAcct, String loginPswd) {
        // 1.根据登录账号查询Admin对象
        AdminExample adminExample = new AdminExample();
        // 创建criteria对象
        AdminExample.Criteria criteria = adminExample.createCriteria();
        // 在其中封装查询条件
        criteria.andLoginAcctEqualTo(loginAcct);
        List<Admin> list = adminMapper.selectByExample(adminExample);
        // 2.判断admin是否为空
        if (list == null || list.size() == 0) {
            // 3.如果为空则抛出异常
            throw new LoginFailedException(CrowdConstant.MESSAGE_LOGIN_FAILED);
        }
        if (list.size() > 1) {
            throw new RuntimeException(CrowdConstant.MESSAGE_SYSTEM_ERROR_LOGIN_NOT_UNIQUE);
        }
        Admin admin = list.get(0);
        if (admin == null) {
            throw new LoginFailedException(CrowdConstant.MESSAGE_LOGIN_FAILED);
        }
        // 4.若不为空则将数据库密码从admin对象中取出
        String userPwdDB = admin.getUserPswd();
        // 5.将表单提交的明文密码加密，对密码进行比较
        String loginPwd = CrowdUtil.md5(loginPswd);
        if (!Objects.equals(userPwdDB, loginPwd)) {
            // 6.如果比较结果不一致则抛出异常
            throw new LoginFailedException(CrowdConstant.MESSAGE_LOGIN_FAILED);
        }
        // 7.如果一致则返回admin对象
        return admin;
    }

    @Override
    public PageInfo<Admin> getPageInfo(String keyword, Integer pageNum, Integer pageSize) {
        // 1调用Pagehelper的静态方法开启分页功能

        PageHelper.startPage(pageNum, pageSize);
        // 2执行查询
        List<Admin> list = adminMapper.selectAdminByKeyword(keyword);
        // 3封装都pageinfo对象中
        return new PageInfo<>(list);
    }

    @Override
    public void remove(Integer adminId) {
        adminMapper.deleteByPrimaryKey(adminId);
    }

    @Override
    public Admin getAdminById(Integer adminId) {
        return adminMapper.selectByPrimaryKey(adminId);
    }

    @Override
    public void update(Admin admin) {
        //selective表示有选择的更新，对于null值的字段不更新
        try {
            adminMapper.updateByPrimaryKeySelective(admin);
        } catch (Exception e) {
            if (e instanceof DuplicateKeyException) {
                //保证更新后的账户名也不冲突，冲突了返回异常信息。
                throw new UpdateAcctAlreadyInUseException(CrowdConstant.MESSAGE_LOGIN_ACCT_ALREADY_IN_USE);
            }
        }
    }

    @Override
    public void saveAdminRoleRelationship(Integer adminId, List<Integer> roleIdList) {
        //为了简化操作：先根据adminId删除旧的数据，再根据roleIdList保存全部新的数据
        //1 根据adminId删除旧的关联关系数据
        adminMapper.deleteOldRelationship(adminId);
        //2 根据roldIdList 和adminId保存新的关联关系
        if (roleIdList != null && roleIdList.size()>0){
            adminMapper.insertNewRelationship(adminId,roleIdList);
        }
    }
}
