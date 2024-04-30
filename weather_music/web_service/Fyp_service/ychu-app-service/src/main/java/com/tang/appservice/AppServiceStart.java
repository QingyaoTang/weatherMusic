package com.tang.appservice;

import com.ruoyi.RuoYiApplication;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan(value = {"com.tang.appservice.mapper"})
public class AppServiceStart {

    public static void main(String[] args) {
        SpringApplication.run(
                new Class[]{
                        AppServiceStart.class,
                        RuoYiApplication.class
                }, args);
        System.out.println("(♥◠‿◠)ﾉﾞ  FYP服务启动成功   ლ(´ڡ`ლ)ﾞ ");
    }

}
