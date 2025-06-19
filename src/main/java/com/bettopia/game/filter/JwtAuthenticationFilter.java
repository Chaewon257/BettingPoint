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
import javax.servlet.http.HttpServletRequest;

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

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		// http 요청 변환
		HttpServletRequest httpReq = (HttpServletRequest) request;
		String uri = httpReq.getRequestURI();

		// 제외할 경로 지정
		if (isExcludedPath(uri)) {
			chain.doFilter(request, response);
			return;
		}

		// Authorization 헤더에서 JWT 토큰이 담겨 있는지 확인
		String authHeader = httpReq.getHeader("Authorization");

		// JWT 토큰 추출 & 검증
		if (authHeader != null && authHeader.startsWith("Bearer ")) {
			String token = authHeader.substring(7); // "Bearer " 제거

			// 인증 정보 생성 및 설정
			if (jwtUtil.validateToken(token)) {
				String userId = jwtUtil.getUserIdFromToken(token);

				UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userId, null,
						null);

				SecurityContextHolder.getContext().setAuthentication(authentication);
			}
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
	}

	private boolean isExcludedPath(String uri) {
		return uri.equals("/") || uri.startsWith("/auth") || // 예: /auth/login, /auth/signup 등
				uri.startsWith("/resources");
	}
}
