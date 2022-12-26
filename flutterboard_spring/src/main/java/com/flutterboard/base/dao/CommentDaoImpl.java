package com.flutterboard.base.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.flutterboard.base.dto.CommentDto;

public class CommentDaoImpl implements CommentDao {
	
	SqlSession sqlSession;
	String nameSpace="com.flutterboard.base.dao.CommentDao";

	//Desc: 댓글 목록 보기
	//Date: 2022-12-26
	@Override
	public List<CommentDto> ShowComment(int boardid) throws Exception {
		return sqlSession.selectList(nameSpace + ".ShowComment");
	}

	//Desc: 댓글 수정
	//Date: 2022-12-26
	@Override
	public void UpdateComment(String commentcontent, int commentid) throws Exception {
		sqlSession.update(nameSpace + ".UpdateComment");
	}

	//Desc: 댓글 삭제
	//Date: 2022-12-26
	@Override
	public void DeleteComment(int commentid) throws Exception {
		sqlSession.update(nameSpace + ".DeleteComment");
	}

}
