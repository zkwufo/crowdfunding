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

    @Override
    public void saveMenu(Menu menu) {
        menuMapper.insert(menu);
    }

    @Override
    public void updateMenu(Menu menu) {
        //因为pid没有传入，所以要使用有选择的更新，保证pid字段不会被置空。
        menuMapper.updateByPrimaryKeySelective(menu);
    }

    @Override
    public void removeMenu(Integer id) {
        menuMapper.deleteByPrimaryKey(id);
    }
}
