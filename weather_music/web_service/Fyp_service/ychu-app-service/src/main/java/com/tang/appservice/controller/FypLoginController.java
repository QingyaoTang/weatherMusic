package com.tang.appservice.controller;

import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.model.LoginBody;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.core.domain.model.RegisterBody;
import com.ruoyi.framework.web.service.SysLoginService;
import com.tang.appservice.service.FypLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;

@RestController
public class FypLoginController {

    @Autowired
    private FypLoginService loginService;


    @PostMapping("/appservice/login")
    public AjaxResult login(@RequestBody LoginBody loginBody) {
        // 生成令牌
        LoginUser user = loginService.login(loginBody.getUsername(), loginBody.getPassword());
        AjaxResult ajax = AjaxResult.success(user);
        return ajax;
    }

    @PostMapping("/appservice/register")
    public AjaxResult register(@RequestBody RegisterBody registerBody) {
        // 生成令牌
        String msg = loginService.register(registerBody);
        AjaxResult ajax;
        if (msg.equals("")){
            ajax = AjaxResult.success("注册成功");
        }else{
            ajax = AjaxResult.success(msg);

        }
        return ajax;
    }

}
