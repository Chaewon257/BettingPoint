package com.bettopia.game.model.auth;

import java.sql.Date;

import com.bettopia.game.model.aws.S3ImagePathDeserializer;
import com.bettopia.game.model.aws.S3ImageUrlSerializer;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserVO {
	private String uid;
	private String user_name;
	private String password;
	private String nickname;
	private String email;
	private Date birth_date;
	private String phone_number;
	private boolean agree_privacy;
	private Date created_at;
	private Date updated_at;
	private Date last_login_at;
	private String role;
	private int point_balance;
	
	@JsonSerialize(using = S3ImageUrlSerializer.class)
    @JsonDeserialize(using = S3ImagePathDeserializer.class)
	private String profile_img;
}
