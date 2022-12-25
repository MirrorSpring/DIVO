package com.flutterboard.base.dao;

import java.util.List;

import com.flutterboard.base.dto.BoardDto;

public interface BoardDao {
	
	public List<BoardDto> ShowMain() throws Exception;
	public BoardDto BoardDetail(int boardid) throws Exception;

}
