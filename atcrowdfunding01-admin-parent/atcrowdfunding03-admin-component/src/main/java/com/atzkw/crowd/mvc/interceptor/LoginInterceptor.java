package com.atzkw.crowd.mvc.interceptor;

import com.atzkw.crowd.constant.CrowdConstant;
import com.atzkw.crowd.entity.Admin;
import com.atzkw.crowd.exception.AccessForbiddenException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor extends HandlerInterceptorAdapter {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1.通过request对象获取Session对象
        HttpSession session = request.getSession();
        // 2.尝试从Session域中获取admin对象
        Admin admin = (Admin)session.getAttribute(CrowdConstant.ATTR_NAME_LOGIN_ADMIN);
        // 3 判断admin对象是否为空
        if(admin == null){
            // 4 抛出异常
            throw new AccessForbiddenException(CrowdConstant.MESSAGE_ACCESS_FORBIDEN);
        }
        //如果 admin不为空则放行

        return true;
    }
}
