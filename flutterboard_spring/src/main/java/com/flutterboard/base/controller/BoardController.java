package com.flutterboard.base.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.flutterboard.base.service.BoardService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class BoardController {
	
	@Autowired
	BoardService service;

	//Desc: 메인화면 출력
	//Date: 2022-12-25
	@RequestMapping("/main")
	public String ShowMain(Model model) throws Exception{
		service.ShowMain(model);
		return "showmain";
	}
	
	//Desc: 게시글 상세보기 출력
	//Date: 2022-12-25
	@RequestMapping("/boarddetail")
	public String BoardDetail(HttpServletRequest request, Model model) throws Exception{
		service.BoardDetail(request, model);
		return "boarddetail";
	}
}
