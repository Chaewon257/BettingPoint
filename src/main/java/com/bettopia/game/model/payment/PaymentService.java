package com.bettopia.game.model.payment;

import com.bettopia.game.model.auth.AuthService;
import com.bettopia.game.model.auth.UserVO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.time.ZonedDateTime;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service
public class PaymentService {

    @Autowired
    private PaymentDAO paymentDAO;

    @Value("${toss_secret_key}")
    private String tossSecretKey;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private AuthService authService;

    public PaymentDTO confirmPayment(PaymentConfirmDTO response, String userId) throws Exception {
//        PaymentDTO payment = paymentDAO.selectByOrderId(response.getOrder_uid());
//
//        if(payment == null) {
//            throw new IllegalArgumentException("존재하지 않는 주문번호입니다.");
//        }
//        if(!PaymentStatus.PENDING.equals(payment.getStatus())) {
//            throw new IllegalArgumentException("이미 처리된 결제입니다.");
//        }
//        if(payment.getAmount() != response.getAmount()) {
//            throw new IllegalArgumentException("결제 금액이 일치하지 않습니다.");
//        }

        String auth = Base64.getEncoder().encodeToString((tossSecretKey+":").getBytes(StandardCharsets.UTF_8));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Basic " + auth);

        Map<String, Object> body = new HashMap<>();
        body.put("paymentKey", response.getPayment_key());
        body.put("orderId", response.getOrder_uid());
        body.put("amount", response.getAmount());

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        PaymentStatus status = PaymentStatus.FAILED;;
        String failure_reason = null;
        String receipt_url = null;
        Date approve_at = null;

        PaymentDTO.PaymentDTOBuilder builder = PaymentDTO.builder()
                .payment_key(response.getPayment_key())
                .order_uid(response.getOrder_uid())
                .amount(response.getAmount());

        try {
            ResponseEntity<String> confirm = restTemplate.postForEntity(
                    "https://api.tosspayments.com/v1/payments/confirm", request, String.class
            );

            if(confirm.getStatusCode().is2xxSuccessful()) {
                JsonNode root = objectMapper.readTree(confirm.getBody());
                String paymentKey = root.path("paymentKey").asText();
                String orderId = root.path("orderId").asText();
                String orderName = root.path("orderName").asText();
                String payType = root.path("method").asText();
                int amount = root.path("totalAmount").asInt();
                receipt_url = root.path("receipt").path("url").asText(null);
                String approvedAtStr = root.path("approvedAt").asText(null);
                if (approvedAtStr != null) {
                    approve_at = Date.from(ZonedDateTime.parse(approvedAtStr).toInstant());
                }
                status = PaymentStatus.PAID;

                builder.payment_key(paymentKey)
                        .order_uid(orderId)
                        .order_name(orderName)
                        .pay_type(payType)
                        .amount(amount)
                        .approve_at(approve_at)
                        .receipt_url(receipt_url);
            } else {
                failure_reason = "HTTP " + confirm.getStatusCodeValue();
            }
        } catch (HttpClientErrorException ex) {
            JsonNode error = objectMapper.readTree(ex.getResponseBodyAsString());
            failure_reason = error.path("code").asText() + ": " + error.path("message").asText();
        }

        builder.status(status)
                .failure_reason(failure_reason);

        PaymentDTO payment = builder.build();

        return paymentDAO.insertPayment(payment, userId);
    }
}
