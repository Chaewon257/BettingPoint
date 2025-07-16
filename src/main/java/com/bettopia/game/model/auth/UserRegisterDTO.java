package com.bettopia.game.model.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserRegisterDTO {
	private String user_name;
	private String password;
	private String password_check;
	private String nickname;
	private String email;
	private String birth_date;
	private String phone_number;
	private boolean agree_privacy;
}