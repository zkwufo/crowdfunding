package com.atzkw.crowd.mvc.handler;

import com.atzkw.crowd.entity.Role;
import com.atzkw.crowd.service.api.RoleService;
import com.atzkw.crowd.util.ResultEntity;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.RequestEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class RoleHandler {

    @Autowired
    private RoleService roleService;

    @ResponseBody
    @RequestMapping("/role/get/page/info.json")
    public ResultEntity<PageInfo<Role>> getPageInfo(
            @RequestParam(value = "pageNum",defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize",defaultValue = "5")Integer pageSize,
            @RequestParam(value = "keyword",defaultValue = "") String keyword){

        PageInfo<Role> pageInfo = roleService.getPageInfo(pageNum, pageSize, keyword);


        return ResultEntity.successWithData(pageInfo);
    }
    @ResponseBody
    @RequestMapping("/role/save.json")
    public ResultEntity<String> saveRole(Role role){
        roleService.saveRole(role);
        return ResultEntity.successWithoutData();
    }
    @ResponseBody
    @RequestMapping("/role/update.json")
    public ResultEntity<String> updateRole(Role role){
        roleService.updateRole(role);
        return ResultEntity.successWithoutData();
    }

    @ResponseBody
    @RequestMapping("/role/remove/by/role/id/array.json")
    public ResultEntity<String> removeRole(@RequestBody List<Integer> roleIdList){
        System.out.println("接受到数据");
        roleService.removeRole(roleIdList);
        return ResultEntity.successWithoutData();
    }
}

