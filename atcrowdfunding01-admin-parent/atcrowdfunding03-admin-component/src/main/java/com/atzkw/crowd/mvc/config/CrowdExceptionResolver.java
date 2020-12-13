package com.atzkw.crowd.mvc.config;

import com.atzkw.crowd.constant.CrowdConstant;
import com.atzkw.crowd.exception.AccessForbiddenException;
import com.atzkw.crowd.exception.LoginAcctAlreadyInUseException;
import com.atzkw.crowd.exception.LoginFailedException;
import com.atzkw.crowd.exception.UpdateAcctAlreadyInUseException;
import com.atzkw.crowd.mvc.interceptor.LoginInterceptor;
import com.atzkw.crowd.util.CrowdUtil;
import com.atzkw.crowd.util.ResultEntity;
import com.google.gson.Gson;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

//@ControllerAdvice 表示当前类是一个基于注解的异常处理类
@ControllerAdvice
public class CrowdExceptionResolver {
    //@ExceptionHandler将一个具体的异常处理类和一个方法关联起来
    @ExceptionHandler(value = NullPointerException.class)
    public ModelAndView resolveNullPointerException(NullPointerException exception, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String viewName="system-error";
        return resolveExceptionUtil(viewName,exception,req,resp);
    }
    @ExceptionHandler(value = UpdateAcctAlreadyInUseException.class)
    public ModelAndView resolveUpdateAcctAlreadyInUseException(UpdateAcctAlreadyInUseException exception, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String viewName="admin-edit";
        return resolveExceptionUtil(viewName,exception,req,resp);
    }
    @ExceptionHandler(value = LoginAcctAlreadyInUseException.class)
    public ModelAndView resolveLoginAcctAlreadyInUseException(LoginAcctAlreadyInUseException exception, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String viewName="admin-add";
        return resolveExceptionUtil(viewName,exception,req,resp);
    }
    //登录失败回到的页面
    @ExceptionHandler(value = LoginFailedException.class)
    public ModelAndView resolveLoginFailedException(LoginFailedException exception, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String viewName="admin-login";
        return resolveExceptionUtil(viewName,exception,req,resp);
    }
    @ExceptionHandler(value = AccessForbiddenException.class)
    public ModelAndView resolveAccessForbiddenException(AccessForbiddenException exception, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String viewName="admin-login";
        return resolveExceptionUtil(viewName,exception,req,resp);
    }
    private ModelAndView resolveExceptionUtil(String page,Exception exception, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        boolean b = CrowdUtil.judgeRequestType(req);
        if(b){
            ResultEntity<Object> resultEntity = ResultEntity.failed(exception.getMessage());
            Gson gson = new Gson();
            String s = gson.toJson(resultEntity);
            resp.getWriter().write(s);
        }
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject(CrowdConstant.ATTR_NAME_EXCEPTION,exception);
        modelAndView.setViewName(page);
        return modelAndView;
    }
}
//
