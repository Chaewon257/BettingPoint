package com.bettopia.game.model.payment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
// 클라이언트에서 결제 요청 시 받는 dto
public class PaymentRequestDTO {
    private int amount;
    private String order_name;
}
