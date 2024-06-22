package com.csabika98.reactivite.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class StaticController {

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("value", "backend");
        return "backend"; // This corresponds to index.html
    }
}
