package com.atzkw.crowd.mvc.handler;

import com.atzkw.crowd.constant.CrowdConstant;
import com.atzkw.crowd.entity.Admin;
import com.atzkw.crowd.service.api.AdminService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import javax.servlet.http.HttpSession;

@Controller
public class AdminHandler {
    @Autowired
    private AdminService adminService;

    @RequestMapping("/admin/do/login.html")
    public String doLogin(@RequestParam("loginAcct") String loginAcct,
                          @RequestParam("loginpswd") String loginPswd,
                          HttpSession httpSession) {
        //调用service方法执行登录检查
        Admin admin = adminService.getAdminByLoginAcct(loginAcct, loginPswd);
        httpSession.setAttribute(CrowdConstant.ATTR_NAME_LOGIN_ADMIN,admin);

        return "redirect:/admin/to/main/page.html";
    }

    @RequestMapping("/admin/do/logout.html")
    public String doLogout(HttpSession httpSession){
        httpSession.invalidate();
        return "redirect:/admin/to/login/page.html";
    }

    @RequestMapping("/admin/get/page.html")
    public String getPageInfo(@RequestParam(value="keyword",defaultValue = "") String keyword,
                              // 默认去第一页
                              @RequestParam(value = "pageNum",defaultValue = "1") Integer pageNum,
                              //默认显示5条
                              @RequestParam(value = "pageSize",defaultValue = "5") Integer pageSize,
                                ModelMap modelMap){
        //调用service方法获取pageInfo对象
        PageInfo<Admin> pageInfo = adminService.getPageInfo(keyword,pageNum,pageSize);
        modelMap.addAttribute(CrowdConstant.ATTR_NAME_PAGE_INFO,pageInfo);
        return "admin-page";
    }
    @RequestMapping("/admin/remove/{adminId}/{pageNum}/{keyword}.html")
    public String remove(@PathVariable("adminId") Integer adminId,
                        @PathVariable("pageNum") Integer pageNum,
                         @PathVariable("keyword") String keyword){
        //执行删除
        adminService.remove(adminId);
        //页面跳转，回到分页
        return "redirect:/admin/get/page.html?pageNum="+pageNum+"&keyword="+keyword;
    }

    @RequestMapping("admin/save.html")
    public String add(Admin admin){
        adminService.saveAdmin(admin);
        return "redirect:/admin/get/page.html?pageNum="+Integer.MAX_VALUE;
    }
    @RequestMapping("admin/to/edit/page.html")
    public String toEditPage(@RequestParam("adminId") Integer adminId,ModelMap modelMap){
        Admin admin = adminService.getAdminById(adminId);
        modelMap.addAttribute("admin",admin);
        return "admin-edit";
    }
    @RequestMapping("admin/update.html")
    public String update(Admin admin,@RequestParam("pageNum") Integer pageNum,@RequestParam("keyword") String keyword){
        adminService.update(admin);
        return "redirect:/admin/get/page.html?pageNum="+pageNum+"&keyword="+keyword;
    }
}
