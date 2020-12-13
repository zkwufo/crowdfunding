package com.atzkw.crowd.service.impl;

import com.atzkw.crowd.entity.Menu;
import com.atzkw.crowd.entity.MenuExample;
import com.atzkw.crowd.mapper.MenuMapper;
import com.atzkw.crowd.service.api.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuServiceImpl implements MenuService {
    @Autowired
    private MenuMapper menuMapper;

    @Override
    public List<Menu> getAll() {
        return menuMapper.selectByExample(new MenuExample());
    }
}
