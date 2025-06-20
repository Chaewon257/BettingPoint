package com.bettopia.game.Exception;

public class InvalidTokenException extends AuthException {
	public InvalidTokenException() {
		super(ExceptionMessage.INVALID_TOKEN);
	}
}
