package com.bettopia.game.model.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PaymentDTO {
    private String uid;
    private String pay_type;
    private int amount;
    private String order_uid;
    private String order_name;
    private String user_uid;
    private String payment_key;
    private PaymentStatus status;
    private Date created_at;
    private Date approve_at;
    private String failure_reason;
    private String receipt_url;
}
