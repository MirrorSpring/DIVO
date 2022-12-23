package com.flutterboard.base.dao;

import org.apache.ibatis.session.SqlSession;

public class UserDaoImpl implements UserDao {
	
	SqlSession sqlSession;
	String nameSpace="com.flutterboard.base.dao.UserDao";

	@Override
	public int Login(String userid, String userpw) throws Exception {
		return sqlSession.selectOne(nameSpace + ".Login");
	}

}
