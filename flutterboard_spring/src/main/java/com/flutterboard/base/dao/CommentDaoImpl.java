package com.flutterboard.base.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.flutterboard.base.dto.CommentDto;

public class CommentDaoImpl implements CommentDao {
	
	SqlSession sqlSession;
	String nameSpace="com.flutterboard.base.dao.CommentDao";

	@Override
	public List<CommentDto> ShowComment(int boardid) throws Exception {
		return sqlSession.selectList(nameSpace + ".ShowComment");
	}

}
