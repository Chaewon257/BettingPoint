package com.bettopia.game.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;


@Configuration
public class AmazonS3Config {

    @Value("${AMAZONPROPERTIES_ACCESSKEY}")
    private String accessKey;
    
    @Value("${AMAZONPROPERTIES_SECRETKEY}")
    private String secretKey;
    
    @Value("${AMAZONPROPERTIES_REGION}")
    private String region;
    
    @Value("${AMAZONPROPERTIES_BUCKETNAME}")
    private String bucketName;

	@Bean
    public AmazonS3Client amazonS3Client() {
        // AWS 자격증명 객체 생성
    	AWSCredentials awsCreds = new BasicAWSCredentials(accessKey, secretKey);
        // Amazon S3 클라이언트 빌드 (지정한 리전으로)
        return (AmazonS3Client) AmazonS3ClientBuilder.standard()
                .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
                .withRegion(region)
                .build();
    }
	
	@Bean
    public String s3BucketName() {
        return bucketName;
    }
}

