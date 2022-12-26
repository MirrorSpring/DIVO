package com.flutterboard.base.dao;

import java.util.List;

import com.flutterboard.base.dto.CommentDto;

public interface CommentDao {
	
	public List<CommentDto> ShowComment(int boardid) throws Exception;
	
	public void UpdateComment(String commentcontent, int commentid) throws Exception;
	
	public void DeleteComment(int commentid) throws Exception;
	
	public void Comment(int boardid, String userid, String commentcontent) throws Exception;

}
