package com.bettopia.game.model.aws;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

public class S3ImagePathDeserializer extends JsonDeserializer<String> {
    private static final String S3_BASE_URL = "https://bettopia-s3-bucket.s3.ap-northeast-2.amazonaws.com/";

    @Override
    public String deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        String fullUrl = p.getText();
        if (fullUrl != null && fullUrl.startsWith(S3_BASE_URL)) {
            return fullUrl.substring(S3_BASE_URL.length());
        }
        return fullUrl; // 원래 경로 그대로 저장
    }
}
