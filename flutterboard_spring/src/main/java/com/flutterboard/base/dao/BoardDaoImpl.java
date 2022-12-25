package com.flutterboard.base.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.flutterboard.base.dto.BoardDto;

public class BoardDaoImpl implements BoardDao {
	
	SqlSession sqlSession;
	String nameSpace="com.flutterboard.base.dao.BoardDao";
	
	//Desc: 메인화면 출력
	//Date: 2022-12-25
	@Override
	public List<BoardDto> ShowMain() throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList(nameSpace + ".ShowMain");
	}

	//Desc: 게시글 상세보기 출력
	//Date: 2022-12-25
	@Override
	public BoardDto BoardDetail(int boardid) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne(nameSpace + ".BoardDetail");
	}

	//Desc: 게시글 쓰기
	//Date: 2022-12-25
	@Override
	public void Write(String writerid, String title, String content) throws Exception {
		sqlSession.insert(nameSpace + ".Write");
		
	}

}
