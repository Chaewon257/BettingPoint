package com.bettopia.game.model.verification;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Random;

import com.bettopia.game.model.auth.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class VerificationService {

	@Autowired
	private VerificationDAO verificationDAO;

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	private AuthService authService;

	// 인증 요청 시
	public void requestVerification(String email) {
		// 인증 코드 생성
		String code = generateVerificationCode();

		// 코드 유효 시간(5분)
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.MINUTE, 5);

		VerificationDTO verification = VerificationDTO.builder()
			.email(email)
			.verification_code(code)
			.expired_at(new Timestamp(cal.getTimeInMillis()))
			.is_verified(false)
			.build();

		verificationDAO.saveOrUpdate(verification);

		sendEmail(email, code);
	}

	// 임시 비밀번호 발급
	public void updatePassword(String email, String userId) {
		String tempPassword = generateTempPassword();

		authService.updatePassword(tempPassword, userId);

		sendTempPassword(email, tempPassword);
	}

	// 임시 비밀번호 이메일 발송
	private void sendTempPassword(String email, String tempPassword) {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(email);
		message.setSubject("[Bettopia] 임시 비밀번호 발급 안내");
		message.setText("임시 비밀번호: " + tempPassword + "\n로그인 후 반드시 비밀번호를 변경해 주세요.");
		mailSender.send(message);
	}

	// 임시 비밀번호 생성
	private String generateTempPassword() {
		String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
		StringBuilder sb = new StringBuilder();
		Random rnd = new Random();
		for (int i = 0; i < 8; i++) {
			sb.append(chars.charAt(rnd.nextInt(chars.length())));
		}
		return sb.toString();
	}

	// 인증번호 확인
	public boolean verifyCode(String email, String code) {
		VerificationDTO verification = verificationDAO.findByEmail(email);

		if(verification == null) {
			throw new RuntimeException("인증요청이 없습니다.");
		}

		if(verification.getExpired_at().before(new java.util.Date())) {
			throw new RuntimeException("인증번호가 만료되었습니다.");
		}

		if(!verification.getVerification_code().equals(code)) {
			throw new RuntimeException("인증번호가 일치하지 않습니다.");
		}

		verificationDAO.markVerified(email);

		return true;
	}

	private void sendEmail(String email, String code) {
		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(email);
		message.setSubject("[Bettopia] 이메일 인증번호 안내");
		message.setText("인증번호: " + code + "\n인증번호 유효시간은 5분입니다.");
		mailSender.send(message);
	}

	private String generateVerificationCode() {
		Random random = new Random();
		int code = 100000 + random.nextInt(900000); // 6자리 숫자
		return String.valueOf(code);
	}

}
