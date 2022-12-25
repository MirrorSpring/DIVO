package com.flutterboard.base.dao;

import org.apache.ibatis.session.SqlSession;

public class UserDaoImpl implements UserDao {
	
	SqlSession sqlSession;
	String nameSpace="com.flutterboard.base.dao.UserDao";

	//Desc: 로그인
	//Date: 2022-12-25
	@Override
	public int Login(String userid, String userpw) throws Exception {
		return sqlSession.selectOne(nameSpace + ".Login");
	}

}
