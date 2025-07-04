package com.bettopia.game.model.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
// 실제 토스페이먼츠에 결제 요청하는 dto
public class PaymentConfirmDTO {
    private String payment_key;
    private String order_uid;
    private int amount;
}
