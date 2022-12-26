package com.flutterboard.base.dao;

import java.util.List;

import com.flutterboard.base.dto.CommentDto;

public interface CommentDao {
	
	public List<CommentDto> ShowComment(int boardid) throws Exception;

}
