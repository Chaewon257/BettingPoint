package com.bettopia.game.model.payment;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public class PaymentDAO {

    @Autowired
    private SqlSession sqlSession;

    String namespace = "com.bpoint.payment.";

    public PaymentDTO insertPayment(PaymentRequestDTO request, String userId){
        String uid = UUID.randomUUID().toString().replaceAll("-", "");
        String order_uid = UUID.randomUUID().toString();

        PaymentDTO payment = PaymentDTO.builder()
                .uid(uid)
                .order_uid(order_uid)
                .amount(request.getAmount())
                .order_name(request.getOrder_name())
                .user_uid(userId)
                .build();

        sqlSession.insert(namespace + "insert", payment);

        return payment;
    }

    public PaymentDTO selectByOrderId(String orderId) {
        return sqlSession.selectOne(namespace + "selectByOrderId", orderId);
    }

    public PaymentDTO updatePayment(PaymentConfirmDTO response, PaymentStatus status, String failureReason, String receiptUrl) {
        PaymentDTO payment = PaymentDTO.builder()
                .status(status)
                .payment_key(response.getPayment_key())
                .failure_reason(failureReason)
                .receipt_url(receiptUrl)
                .build();

        sqlSession.update(namespace + "update", payment);

        PaymentDTO result = selectByOrderId(response.getOrder_uid());

        return result;
    }
}
