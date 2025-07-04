package com.bettopia.game.model.auth;

import java.sql.Date;

import org.springframework.web.multipart.MultipartFile;

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
public class UserUpdateRequestDTO {
	private String password; // 현재 비밀번호
	private String new_password;
	private String nickname;
	private String phone_number;
    private Date birth_date;
    
    @JsonSerialize(using = S3ImageUrlSerializer.class)
    @JsonDeserialize(using = S3ImagePathDeserializer.class)
	private String profile_img_url;
    
    private MultipartFile profile_image; // 새로 업로드할 이미지 (선택적)
}
