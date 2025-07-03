package com.bettopia.game.model.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PaymentResponseDTO {
    private String uid;
    private String payment_key;
    private String order_uid;
    private String order_name;
    private int amount;
    private String user_name;
    private String failure_reason;
    private String receipt_url;
    private PaymentStatus status;
    private Date approve_at;
}
