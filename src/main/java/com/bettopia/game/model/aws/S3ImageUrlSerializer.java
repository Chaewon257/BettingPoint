package com.bettopia.game.model.aws;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

public class S3ImageUrlSerializer extends JsonSerializer<String> {
	
	private static final String S3_BASE_URL = "https://bettopia-bucket.s3.ap-southeast-2.amazonaws.com/";
	
	@Override
	public void serialize(String img_path, JsonGenerator gen, SerializerProvider serializers) throws IOException {
		if (img_path == null || img_path.isBlank()) {
            gen.writeNull();
        } else {
            gen.writeString(S3_BASE_URL + img_path);
        }
		
	}
	
}
