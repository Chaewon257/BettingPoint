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

    public PaymentDTO insertPayment(PaymentDTO response, String userId){
        String uid = UUID.randomUUID().toString().replaceAll("-", "");

        PaymentDTO payment = PaymentDTO.builder()
                .uid(uid)
                .payment_key(response.getPayment_key())
                .order_uid(response.getOrder_uid())
                .order_name(response.getOrder_name())
                .pay_type(response.getPay_type())
                .amount(response.getAmount())
                .user_uid(userId)
                .status(response.getStatus())
                .approve_at(response.getApprove_at())
                .failure_reason(response.getFailure_reason())
                .receipt_url(response.getReceipt_url())
                .build();

        sqlSession.insert(namespace + "insert", payment);

        return payment;
    }

    public PaymentDTO selectByOrderId(String orderId) {
        return sqlSession.selectOne(namespace + "selectByOrderId", orderId);
    }
}
