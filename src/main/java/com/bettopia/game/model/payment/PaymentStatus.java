package com.bettopia.game.model.payment;

public enum PaymentStatus {
    PENDING, // 결제 대기
    PAID, // 결제 완료
    FAILED, // 결제 실패
    CANCELED // 결제 취소
}
