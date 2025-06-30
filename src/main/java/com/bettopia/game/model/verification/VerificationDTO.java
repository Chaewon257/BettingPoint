package com.bettopia.game.model.verification;

import java.sql.Timestamp;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class VerificationDTO {
	private String email;
	private String verification_code;
	private Timestamp expired_at;
	private boolean is_verified;
}
