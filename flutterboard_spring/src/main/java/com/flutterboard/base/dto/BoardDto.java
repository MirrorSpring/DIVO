package com.flutterboard.base.dto;

public class BoardDto {

	int boardid;
	String writerid;
	String username;
	String title;
	String writedate;
	String updatedate;

	public BoardDto(int boardid, String writerid, String username, String title, String writedate, String updatedate) {
		super();
		this.boardid = boardid;
		this.writerid = writerid;
		this.username = username;
		this.title = title;
		this.writedate = writedate;
		this.updatedate = updatedate;
	}

	public int getBoardid() {
		return boardid;
	}

	public void setBoardid(int boardid) {
		this.boardid = boardid;
	}

	public String getWriterid() {
		return writerid;
	}

	public void setWriterid(String writerid) {
		this.writerid = writerid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getWritedate() {
		return writedate;
	}

	public void setWritedate(String writedate) {
		this.writedate = writedate;
	}

	public String getUpdatedate() {
		return updatedate;
	}

	public void setUpdatedate(String updatedate) {
		this.updatedate = updatedate;
	}

}