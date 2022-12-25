package com.flutterboard.base.dao;

import java.util.List;

import com.flutterboard.base.dto.BoardDto;

public interface BoardDao {
	
	public List<BoardDto> ShowMain() throws Exception;
	public BoardDto BoardDetail(int boardid) throws Exception;
	public void Write(String writerid, String title, String content) throws Exception;
	public void UpdateBoard(String title, String content, int boardid) throws Exception;

}
