package com.bettopia.game.Exception;

public class UserNotFoundEception extends AuthException {
	public UserNotFoundEception() {
		super(ExceptionMessage.USER_NOT_FOUND);
	}
}
