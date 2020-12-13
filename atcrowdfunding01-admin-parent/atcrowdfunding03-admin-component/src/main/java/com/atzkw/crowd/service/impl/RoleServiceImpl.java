package com.atzkw.crowd.service.impl;

import com.atzkw.crowd.entity.Role;
import com.atzkw.crowd.entity.RoleExample;
import com.atzkw.crowd.mapper.RoleMapper;
import com.atzkw.crowd.service.api.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleMapper roleMapper;

    @Override
    public PageInfo<Role> getPageInfo(Integer pageNum, Integer pageSize, String keyword) {
        //1 开启分页功能
        PageHelper.startPage(pageNum,pageSize);
        //2 执行查询
        List<Role> roles = roleMapper.selectRoleByKeyword(keyword);
        //3 封装为pageInfo对象返回
        return new PageInfo<>(roles);
    }

    @Override
    public void saveRole(Role role) {
        roleMapper.insert(role);
    }

    @Override
    public void updateRole(Role role) {
        roleMapper.updateByPrimaryKey(role);
    }

    @Override
    public void removeRole(List<Integer> roleIdList) {
        RoleExample roleExample = new RoleExample();
        RoleExample.Criteria criteria = roleExample.createCriteria();
        criteria.andIdIn(roleIdList);
        roleMapper.deleteByExample(roleExample);
    }
}
