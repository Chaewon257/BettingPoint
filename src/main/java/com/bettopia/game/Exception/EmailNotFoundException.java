package com.bettopia.game.Exception;

public class EmailNotFoundException extends AuthException {
	public EmailNotFoundException() {
		super(ExceptionMessage.EMAIL_NOT_FOUND);
	}
}
