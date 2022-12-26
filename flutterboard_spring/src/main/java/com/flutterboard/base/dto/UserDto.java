package com.flutterboard.base.dto;

public class UserDto {

	String userid;
	String username;
	String userpw;
	String birthday;
	
	public UserDto(String userid, String username, String userpw, String birthday) {
		super();
		this.userid = userid;
		this.username = username;
		this.userpw = userpw;
		this.birthday = birthday;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getUserpw() {
		return userpw;
	}

	public void setUserpw(String userpw) {
		this.userpw = userpw;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

}
