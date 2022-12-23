package com.flutterboard.base.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.flutterboard.base.dao.BoardDao;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDao dao;

}
