package com.scala_training.helloworld.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {

    // @GetMapping(path = {"/hello", "/user/{message}"})
    // public String sendGreetings(@PathVariable(required=false,name="message") String message = null) {
    //     if (message != null) {
    //         return "Hello, " + message;
    //     }
    //     else { 
    //         return "Hello"; 
    //     }
    // }

    @GetMapping("/hello")
    public String sendGreetings() {
        if ("1".equals("1")) {
            return "Hello World!";
        } else {return "Hello World!";}
        
        
    }
}
