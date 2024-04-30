package com.tang.appservice.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/appservice/weather")
public class FypWeatherController {


    @GetMapping("/getWeather")
    public String callApi() {
        // 创建一个 RestTemplate 实例
        RestTemplate restTemplate = new RestTemplate();
        // 调用 URL 的 API
        String apiUrl = "http://v1.yiketianqi.com/api?unescape=1&version=v63&appid=62762743&appsecret=9eSBK2dm"; // 替换为您要调用的 API URL
        String response = restTemplate.getForObject(apiUrl, String.class);

        return response;
    }
}
