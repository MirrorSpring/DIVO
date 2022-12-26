package com.flutterboard.base.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

public class UserDaoImpl implements UserDao {

	SqlSession sqlSession;
	String nameSpace = "com.flutterboard.base.dao.UserDao";

	// Desc: 로그인
	// Date: 2022-12-25
	@Override
	public int Login(String userid, String userpw) throws Exception {
		return sqlSession.selectOne(nameSpace + ".Login");
	}

	// Desc: ID 찾기
	// Date: 2022-12-25
	@Override
	public List<String> FindId(String username, String birthday) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList(nameSpace + ".FindId");
	}

	// Desc: 비밀번호 찾기
	// Date: 2022-12-26
	@Override
	public int FindPw(String username, String userid, String birthday) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne(nameSpace + ".FindPw");
	}

	//Desc: 비밀번호 재설정
	//Date: 2022-12-26
	@Override
	public void ResetPw(String userpw, String userid) throws Exception {
		// TODO Auto-generated method stub
		sqlSession.update(nameSpace + ".ResetPw");
	}

	//Desc: 회원가입
	//Date: 2022-12-26
	@Override
	public void Join(String userid, String userpw, String username, String birthday) throws Exception {
		sqlSession.insert(nameSpace + ".Join");
	}

	//Desc: 컴백 체크
	//Date: 2022-12-26
	@Override
	public int ComebackCheck(String userid) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne(nameSpace + ".CombackCheck");
	}

	@Override
	public void ComebackJoin(String userid, String userpw, String username, String birthday) throws Exception {
		sqlSession.update(nameSpace + ".ComebackJoin");
	}

	//Desc: ID 중복체크
	//Date: 2022-12-26
	@Override
	public int IDCheck(String userid) throws Exception {
		return sqlSession.selectOne(nameSpace + ".IDCheck");
	}

}
