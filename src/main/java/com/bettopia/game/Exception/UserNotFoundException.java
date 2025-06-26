package com.bettopia.game.Exception;

public class UserNotFoundException extends AuthException {
	public UserNotFoundException() {
		super(ExceptionMessage.USER_NOT_FOUND);
	}
}
