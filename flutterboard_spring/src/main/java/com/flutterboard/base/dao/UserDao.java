package com.flutterboard.base.dao;

import java.util.List;

public interface UserDao {

	public int Login(String userid, String userpw) throws Exception;

	public List<String> FindId(String username, String birthday) throws Exception;

	public int FindPw(String username, String userid, String birthday) throws Exception;
	
	public void ResetPw(String userpw, String userid) throws Exception;

}
