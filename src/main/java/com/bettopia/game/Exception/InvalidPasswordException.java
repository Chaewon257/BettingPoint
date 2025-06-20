package com.bettopia.game.Exception;

public class InvalidPasswordException extends AuthException {
	public InvalidPasswordException() {
		super(ExceptionMessage.INVALID_PASSWORD);
	}
}