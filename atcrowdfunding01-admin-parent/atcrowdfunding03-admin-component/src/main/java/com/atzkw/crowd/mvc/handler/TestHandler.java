package com.atzkw.crowd.mvc.handler;

import com.atzkw.crowd.entity.Admin;
import com.atzkw.crowd.entity.ParamData;
import com.atzkw.crowd.service.api.AdminService;
import com.atzkw.crowd.util.CrowdUtil;
import com.atzkw.crowd.util.ResultEntity;
import org.slf4j.ILoggerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class TestHandler {

    @Autowired
    private AdminService adminService;

    private Logger logger = LoggerFactory.getLogger(TestHandler.class);

    @RequestMapping("/test/ssm.html")
    public String testSsm(ModelMap modelMap) {

        List<Admin> adminList = adminService.getAll();
        modelMap.addAttribute("adminList", adminList);

        return "target";
    }

    @RequestMapping("/send/arrayOne.html")
    public String testReceiveArrayOne(@RequestParam("array[]") List<Integer> array) {
        for (Integer integer : array) {
            System.out.println(integer);
        }
        return "target";
    }

    @RequestMapping("/send/arrayTwo.html")
    public String testReceiveArrayTwo(ParamData paramData) {
        List<Integer> array = paramData.getArray();
        for (Integer integer : array) {
            System.out.println(integer);
        }
        return "target";
    }

    @RequestMapping("/send/arrayThree.html")
    public String testReceiveArrayThree(@RequestBody List<Integer> array) {
        for (Integer integer : array) {
            logger.info("" + integer);
        }
        return "target";
    }

    @ResponseBody
    @RequestMapping("/send/resultEntity.json")
    public ResultEntity<Admin> resultEntity(@RequestBody Admin admin, HttpServletRequest req) {
        boolean b = CrowdUtil.judgeRequestType(req);
        logger.info(String.valueOf(b));
        logger.info(admin.toString());
        return ResultEntity.successWithData(admin);
    }
    @RequestMapping("/send/error.html")
    public String testError(ModelMap modelMap) {

        List<Admin> adminList = adminService.getAll();
        modelMap.addAttribute("adminList", adminList);
//        空指针异常
//        String a = null;
//        System.out.println(a.length());
        System.out.println(10/0);
        return "target";
    }
}
