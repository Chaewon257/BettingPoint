package com.bettopia.game.Exception;

public class MissingCredentialsException extends AuthException {
	public MissingCredentialsException() {
		super(ExceptionMessage.MISSING_CREDENTIALS);
	}
}
