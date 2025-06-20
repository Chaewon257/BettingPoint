package com.bettopia.game.Exception;

public class UnauthorizedAccessException extends AuthException {
	public UnauthorizedAccessException() {
		super(ExceptionMessage.UNAUTHORIZED_ACCESS);
	}
}
