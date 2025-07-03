package com.bettopia.game.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Value("${toss_client_key}")
    private String tossClientKey;

    @GetMapping
    public String payment(Model model) {
        model.addAttribute("tossClientKey", tossClientKey);
        return "payment/payment";
    }
}
