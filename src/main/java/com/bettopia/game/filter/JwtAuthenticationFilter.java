package com.bettopia.game.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.bettopia.game.util.JWTUtil;

@WebFilter("/JwtAuthenticationFilter")
public class JwtAuthenticationFilter implements Filter {
	private JWTUtil jwtUtil;

	public JwtAuthenticationFilter() {
		// 기본 생성자 필수
	}

	public void setJwtUtil(JWTUtil jwtUtil) {
		this.jwtUtil = jwtUtil;
	}

	@Override
	public void init(FilterConfig filterConfig) {
		ServletContext context = filterConfig.getServletContext();
		
		// Spring의 WebApplicationContext에서 JWTUtil Bean 가져오기
		WebApplicationContext springContext = WebApplicationContextUtils.getWebApplicationContext(context);
		this.jwtUtil = springContext.getBean(JWTUtil.class);
	}
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		HttpServletRequest httpReq = (HttpServletRequest) request;
		HttpServletResponse httpRes = (HttpServletResponse) response;
		String uri = httpReq.getRequestURI();

		// 제외할 경로 지정
		if (isExcludedPath(uri)) {
			chain.doFilter(request, response);
			return;
		}

		// Authorization 헤더에서 JWT 토큰이 담겨 있는지 확인
		String authHeader = httpReq.getHeader("Authorization");
		String token = null;

		// JWT 토큰 추출 & 검증
		if (authHeader != null && authHeader.startsWith("Bearer ")) {
			token = authHeader.substring(7);
		}
		
		if (token != null) {
			if (jwtUtil.validateToken(token)) {
				// accessToken 유효할 때
				String userId = jwtUtil.getUserIdFromToken(token);
				
				setAuthentication(userId);
			} else if (jwtUtil.isTokenExpired(token)) {
				
				// accessToken 만료 → refreshToken 확인
				String refreshToken = getRefreshTokenFromCookie(httpReq);

				if (refreshToken != null && jwtUtil.validateToken(refreshToken)) {
					String userId = jwtUtil.getUserIdFromToken(refreshToken);

					// refreshToken으로 사용자 uid 추출
					String newAccessToken = jwtUtil.generateAccessToken(userId);

					// 헤더에 새 토큰 설정 (클라이언트가 받을 수 있도록)
					httpRes.setHeader("New-Access-Token", "Bearer " + newAccessToken);

					setAuthentication(userId);
				}
			}
		}

		chain.doFilter(request, response);
	}
	
	private void setAuthentication(String userId) {
		UsernamePasswordAuthenticationToken authentication =
				new UsernamePasswordAuthenticationToken(userId, null, null);
		SecurityContextHolder.getContext().setAuthentication(authentication);
	}
	
	private String getRefreshTokenFromCookie(HttpServletRequest request) {
		if (request.getCookies() != null) {
			for (Cookie cookie : request.getCookies()) {
				if ("refreshToken".equals(cookie.getName())) {
					return cookie.getValue();
				}
			}
		}
		return null;
	}

	private boolean isExcludedPath(String uri) {
		return uri.equals("/") || uri.startsWith("/auth") || // 예: /auth/login, /auth/signup 등
				uri.startsWith("/resources");
	}

	@Override
	public void destroy() {
	}
}
