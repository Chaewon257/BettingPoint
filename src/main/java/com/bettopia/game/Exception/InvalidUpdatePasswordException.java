package com.bettopia.game.Exception;

public class InvalidUpdatePasswordException extends RuntimeException {
    public InvalidUpdatePasswordException() {
        super(ExceptionMessage.INVALID_UPDATE_PASSWORD);
    }
}