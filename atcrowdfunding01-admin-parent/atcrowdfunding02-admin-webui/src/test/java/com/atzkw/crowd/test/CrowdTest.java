package com.atzkw.crowd.test;

import com.atzkw.crowd.entity.Admin;
import com.atzkw.crowd.entity.Role;
import com.atzkw.crowd.mapper.AdminMapper;
import com.atzkw.crowd.mapper.RoleMapper;
import com.atzkw.crowd.service.api.AdminService;
import com.atzkw.crowd.service.api.RoleService;
import com.atzkw.crowd.util.CrowdUtil;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.mapper.MapperScannerConfigurer;
import org.slf4j.ILoggerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

//在类上标记必要的注解，Spring整合Junit
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml","classpath:spring-persist-tx.xml"})
public class CrowdTest {
    @Autowired
    private DataSource dataSource;

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private AdminService adminService;

    @Autowired
    private RoleMapper roleMapper;

    @Test
    public void testAddRole(){
        for(int i=0;i<20;i++){
            Role role = new Role(null,"zkwufo"+i);
            roleMapper.insert(role);
        }
    }

    @Test
    public void testTx(){
        Admin admin = new Admin(null, "zkwufo", "12345", "王", "zkwufo@qq.com", null);
        adminService.saveAdmin(admin);
    }
    @Test
    public void testGetALL(){
        List<Admin> all = adminService.getAll();
        System.out.println(all);
    }

    @Test
    public void testLog() {
        //1 获取logger对象
        Logger logger = LoggerFactory.getLogger(CrowdTest.class);//通常为当前类的class
        logger.debug("hello i love debug");
        logger.debug("hello i love debug");
        logger.debug("hello i love debug");

        logger.info("hello i love info");
        logger.info("hello i love info");
        logger.info("hello i love info");

        logger.warn("i love warn!!!!");
        logger.warn("i love warn!!!!");
        logger.warn("i love warn!!!!");

        logger.error("i don't like error!!!!");
        logger.error("i don't like error!!!!");
        logger.error("i don't like error!!!!");
    }

    @Test
    public void testInsertAdmin() {
        for(int i=0;i<30;i++){
            String s = CrowdUtil.md5("12345");
            Admin admin = new Admin(null,"ads"+i,s,"adsu"+i,"tom@qq.com",null);
            adminMapper.insert(admin);
        }
    }

    @Test
    public void testConnection() throws SQLException {
        Connection connection = dataSource.getConnection();
        System.out.println(connection);
    }
}
