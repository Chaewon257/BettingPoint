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
import java.util.Base64;
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

    public PaymentDTO requestPayment(PaymentRequestDTO request, String userId) {
        return paymentDAO.insertPayment(request, userId);
    }


    public PaymentResponseDTO confirmPayment(PaymentConfirmDTO response, String userId) throws Exception {
        PaymentDTO payment = paymentDAO.selectByOrderId(response.getOrder_uid());

        if(payment == null) {
            throw new IllegalArgumentException("존재하지 않는 주문번호입니다.");
        }
        if(!PaymentStatus.PENDING.equals(payment.getStatus())) {
            throw new IllegalArgumentException("이미 처리된 결제입니다.");
        }
        if(payment.getAmount() != response.getAmount()) {
            throw new IllegalArgumentException("결제 금액이 일치하지 않습니다.");
        }

        String auth = Base64.getEncoder().encodeToString((tossSecretKey+":").getBytes(StandardCharsets.UTF_8));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Basic " + auth);

        Map<String, Object> body = new HashMap<>();
        body.put("payment_key", response.getPayment_key());
        body.put("order_uid", response.getOrder_uid());
        body.put("amount", response.getAmount());

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        PaymentStatus status;
        String failure_reason = null;
        String receipt_url = null;

        try {
            ResponseEntity<String> confirm = restTemplate.postForEntity(
                    "https://api.tosspayments.com/v1/payments/confirm", request, String.class
            );

            if(confirm.getStatusCode().is2xxSuccessful()) {
                status = PaymentStatus.PAID;
                JsonNode root = objectMapper.readTree(confirm.getBody());
                if(root.has("receipt") && root.get("receipt").has("url")) {
                    receipt_url = root.get("receipt").get("url").asText();
                }
            } else {
                status = PaymentStatus.FAILED;
                failure_reason = "HTTP " + confirm.getStatusCodeValue();
            }
        } catch (HttpClientErrorException ex) {
            status = PaymentStatus.FAILED;
            JsonNode error = objectMapper.readTree(ex.getResponseBodyAsString());
            failure_reason = error.path("code").asText() + ": " + error.path("message").asText();
        }

        PaymentDTO result = paymentDAO.updatePayment(response, status, failure_reason, receipt_url);
        UserVO user = authService.findByUid(userId);

        PaymentResponseDTO confirmResponse = PaymentResponseDTO.builder()
                .uid(result.getUid())
                .payment_key(result.getPayment_key())
                .order_uid(result.getOrder_uid())
                .order_name(result.getOrder_name())
                .status(result.getStatus())
                .approve_at(result.getApprove_at())
                .failure_reason(result.getFailure_reason())
                .amount(result.getAmount())
                .user_name(user.getUser_name())
                .receipt_url(result.getReceipt_url())
                .build();

        return confirmResponse;
    }
}
