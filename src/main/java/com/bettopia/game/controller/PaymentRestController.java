package com.bettopia.game.controller;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.history.HistoryService;
import com.bettopia.game.model.history.PointHistoryDTO;
import com.bettopia.game.model.payment.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payment")
public class PaymentRestController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private AuthService authService;

    @Autowired
    private HistoryService historyService;

    @PostMapping("/confirm")
    public PaymentDTO confirmPayment(@RequestBody PaymentConfirmDTO response,
                                     @RequestHeader("Authorization") String authHeader) throws Exception {
        String userId = authService.validateAndGetUserId(authHeader);
        PaymentDTO payment = paymentService.confirmPayment(response, userId);

        if(payment.getStatus().equals(PaymentStatus.PAID)) {
            int netPoint = (int) Math.round(payment.getAmount() / 1.1);
            authService.addPoint(netPoint, userId);
            historyService.insertPointHistory(userId, netPoint);
        }

        return payment;
    }
}
