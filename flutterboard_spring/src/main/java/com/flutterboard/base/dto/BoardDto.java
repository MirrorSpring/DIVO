package com.flutterboard.base.dto;

import java.time.LocalDateTime;

public class BoardDto {

	int boardid;
	String writerid;
	String username;
	String title;
	String writedate;
	String boardupdatedate;
	String content;

	public BoardDto(String writerid, String username, String title, String writedate, String boardupdatedate,
			String content) {
		super();
		this.writerid = writerid;
		this.username = username;
		this.title = title;
		this.writedate = writedate;
		this.boardupdatedate = boardupdatedate;
		this.content = content;
	}

	public BoardDto(int boardid, String writerid, String username, String title, String writedate, String boardupdatedate) {
		super();
		this.boardid = boardid;
		this.writerid = writerid;
		this.username = username;
		this.title = title;
		this.writedate = writedate;
		this.boardupdatedate = boardupdatedate;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
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

	public String getBoardupdatedate() {
		return boardupdatedate;
	}

	public void setBoardupdatedate(String boardupdatedate) {
		this.boardupdatedate = boardupdatedate;
	}

}
