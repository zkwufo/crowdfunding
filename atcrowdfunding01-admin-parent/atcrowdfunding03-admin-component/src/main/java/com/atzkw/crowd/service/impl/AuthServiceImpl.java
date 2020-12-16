package com.atzkw.crowd.service.impl;

import com.atzkw.crowd.mapper.AuthMapper;
import com.atzkw.crowd.service.api.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthServiceImpl implements AuthService {
    @Autowired
    private AuthMapper authMapper;
}
