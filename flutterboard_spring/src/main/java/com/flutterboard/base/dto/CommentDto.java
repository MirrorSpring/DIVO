package com.flutterboard.base.dto;

public class CommentDto {

	int commentid;
	String c_userid;
	String username;
	String commentcontent;
	String commentwritedate;
	String commentupdatedate;
	
	public CommentDto(int commentid, String c_userid, String username, String commentcontent,
			String commentwritedate, String commentupdatedate) {
		super();
		this.commentid = commentid;
		this.c_userid = c_userid;
		this.username = username;
		this.commentcontent = commentcontent;
		this.commentwritedate = commentwritedate;
		this.commentupdatedate = commentupdatedate;
	}

	public int getCommentid() {
		return commentid;
	}

	public void setCommentid(int commentid) {
		this.commentid = commentid;
	}

	public String getC_userid() {
		return c_userid;
	}

	public void setC_userid(String c_userid) {
		this.c_userid = c_userid;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getCommentcontent() {
		return commentcontent;
	}

	public void setCommentcontent(String commentcontent) {
		this.commentcontent = commentcontent;
	}

	public String getCommentwritedate() {
		return commentwritedate;
	}

	public void setCommentwritedate(String commentwritedate) {
		this.commentwritedate = commentwritedate;
	}

	public String getCommentupdatedate() {
		return commentupdatedate;
	}

	public void setCommentupdatedate(String commentupdatedate) {
		this.commentupdatedate = commentupdatedate;
	}

}
