package com.atzkw.crowd.service.impl;

import com.atzkw.crowd.entity.Auth;
import com.atzkw.crowd.entity.AuthExample;
import com.atzkw.crowd.mapper.AuthMapper;
import com.atzkw.crowd.service.api.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class AuthServiceImpl implements AuthService {
    @Autowired
    private AuthMapper authMapper;

    @Override
    public List<Auth> getAll() {
        return authMapper.selectByExample(new AuthExample());
    }

    @Override
    public List<Integer> getAssignAuthIdByRoleId(Integer roleId) {
        return authMapper.getAssignAuthIdByRoleId(roleId);
    }

    @Override
    public void saveRoleAuthRelationship(Map<String, List<Integer>> map) {
        //1 获取roleId的值
        List<Integer> roleIdList = map.get("roleId");
        Integer roleId = roleIdList.get(0);
        //2 删除旧关联关系数据
        authMapper.deleteOldRelationship(roleId);
        //3 获取authIdList
        List<Integer> authIdArray = map.get("authIdArray");
        //4 判断是否有效
        if (authIdArray != null && authIdArray.size() > 0) {
            authMapper.insertNewRelationship(roleId,authIdArray);
        }
    }
}
