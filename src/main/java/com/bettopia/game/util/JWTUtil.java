package com.bettopia.game.util;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

@Component
public class JWTUtil {
	@Value("${JWT_SECRET}")
	private String secretKey;

	@Value("${JWT_ACCESS_TOKEN_EXPIRATION}")
	private long accessTokenExpiration;

	@Value("${JWT_REFRESH_TOKEN_EXPIRATION}")
	private long refreshTokenExpiration;

	private Key key;

	@PostConstruct
	public void init() {
		this.key = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
	}

	public String generateAccessToken(String userId) {
		return buildToken(userId, accessTokenExpiration);
	}

	public String generateRefreshToken(String userId) {
		return buildToken(userId, refreshTokenExpiration);
	}

	private String buildToken(String userId, long expiration) {
		Date now = new Date();
		Date expiryDate = new Date(now.getTime() + expiration);

		return Jwts.builder().setSubject(userId).setIssuedAt(now).setExpiration(expiryDate)
				.signWith(key, SignatureAlgorithm.HS256).compact();
	}

	public boolean validateToken(String token) {
		try {
			Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
			return true;
		} catch (ExpiredJwtException e) {
			// 만료된 토큰
			return false;
		} catch (JwtException e) {
			// 잘못된 토큰
			return false;
		}
	}

	public String getUserIdFromToken(String token) {
		return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token).getBody().getSubject();
	}
}
