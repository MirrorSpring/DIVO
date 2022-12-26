package com.flutterboard.base.dao;

import java.util.List;

import com.flutterboard.base.dto.UserDto;

public interface UserDao {

	public String Login(String userid, String userpw) throws Exception;

	public List<String> FindId(String username, String birthday) throws Exception;

	public int FindPw(String username, String userid, String birthday) throws Exception;
	
	public void ResetPw(String userpw, String userid) throws Exception;
	
	public void Join(String userid, String userpw, String username, String birthday) throws Exception;
	
	public int ComebackCheck(String userid) throws Exception;
	
	public void ComebackJoin(String userid, String userpw, String username, String birthday) throws Exception;
	
	public int IDCheck(String userid) throws Exception;
	
	public UserDto MyPage(String userid) throws Exception;
	
	public void UpdateUser(String username, String userpw, String birthday, String userid) throws Exception;

}
