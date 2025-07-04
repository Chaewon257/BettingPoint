package com.bettopia.game.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class TossPaymentConfig {

    @Value("${toss_client_key}")
    private String tossClientKey;

    @Value("${toss_secret_key}")
    private String tossSecretKey;
}
