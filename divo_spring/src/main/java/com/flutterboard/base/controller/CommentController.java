package com.flutterboard.base.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.flutterboard.base.service.CommentService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CommentController {
	
	@Autowired
	CommentService service;
	
	//Desc: 댓글 목록 보기
	//Date: 2022-12-26
	@RequestMapping("/showcomment")
	public String ShowComment(HttpServletRequest reqeust, Model model) throws Exception{
		service.ShowComment(reqeust, model);
		return "result";
	}

	//Desc: 댓글 수정
	//Date: 2022-12-26
	@RequestMapping("/updatecomment")
	public void UpdateComment(HttpServletRequest request) throws Exception{
		service.UpdateComment(request);
	}
	
	//Desc: 댓글 삭제
	//Date: 2022-12-26
	@RequestMapping("/deletecomment")
	public void DeleteComment(HttpServletRequest request) throws Exception{
		service.DeleteComment(request);
	}
	
	//Desc: 댓글 쓰기
	//Date: 2022-12-27
	@RequestMapping("/comment")
	public void Comment(HttpServletRequest request) throws Exception{
		service.Comment(request);
	}
}
