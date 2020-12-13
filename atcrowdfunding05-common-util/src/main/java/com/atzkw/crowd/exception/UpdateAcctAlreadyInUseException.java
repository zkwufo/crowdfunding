package com.atzkw.crowd.exception;

import java.util.DuplicateFormatFlagsException;

public class UpdateAcctAlreadyInUseException extends RuntimeException {
    public UpdateAcctAlreadyInUseException() {
        super();
    }

    public UpdateAcctAlreadyInUseException(String message) {
        super(message);
    }

    public UpdateAcctAlreadyInUseException(String message, Throwable cause) {
        super(message, cause);
    }

    public UpdateAcctAlreadyInUseException(Throwable cause) {
        super(cause);
    }

    protected UpdateAcctAlreadyInUseException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
