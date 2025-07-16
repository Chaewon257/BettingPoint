package com.bettopia.game.Exception;

public class SessionExpiredException extends AuthException {
	public SessionExpiredException() {
		super(ExceptionMessage.SESSION_EXPIRED);
	}
}
