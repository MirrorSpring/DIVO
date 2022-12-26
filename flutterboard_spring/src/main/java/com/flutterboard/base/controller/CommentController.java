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
	
	@RequestMapping("/showcomment")
	public String ShowComment(HttpServletRequest reqeust, Model model) throws Exception{
		service.ShowComment(reqeust, model);
		return "result";
	}

}
