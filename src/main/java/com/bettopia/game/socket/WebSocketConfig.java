package com.bettopia.game.socket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

// 웹소켓 설정
@Configuration
@EnableWebSocket
@ComponentScan(basePackages = "com.bettopia") // 또는 포함 경로 지정
public class WebSocketConfig implements WebSocketConfigurer {

	@Autowired
	private TurtleGameWebSocketHandler turtleGameWebSocketHandler;
	@Autowired
	private TurtleRunWebsocketHandler turtleRunWebSocketHandler;
	@Autowired
	private HttpHandshakeInterceptor httpHandshakeInterceptor;

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(turtleGameWebSocketHandler, "/ws/game/turtle/**")
				// 다른 게임에서 사용 시 엔드포인트 추가
				.setAllowedOrigins("*").addInterceptors(httpHandshakeInterceptor);
		registry.addHandler(turtleRunWebSocketHandler, "/ws/game/turtle/**")
				// 다른 게임에서 사용 시 엔드포인트 추가
				.setAllowedOrigins("*").addInterceptors(httpHandshakeInterceptor);
	}
}
