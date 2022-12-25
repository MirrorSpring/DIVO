package com.flutterboard.base.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.flutterboard.base.service.UserService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UserController {

	@Autowired
	UserService service;

	// Desc: 로그인
	// Date: 2022-12-25
	@RequestMapping("/login")
	public String login(HttpServletRequest request, Model model) throws Exception {
		service.Login(request, model);
		return "result";
	}

	// Desc: ID 찾기
	// Date: 2022-12-25
	@RequestMapping("/findid")
	public String findid(HttpServletRequest request, Model model) throws Exception {
		service.FindId(request, model);
		return "result";
	}

	// Desc: 비밀번호 찾기
	// Date: 2022-12-26
	@RequestMapping("/findpw")
	public String findpw(HttpServletRequest request, Model model) throws Exception {
		service.FindPw(request, model);
		return "result";
	}

	// Desc: 비밀번호 재설정
	// Date: 2022-12-26
	@RequestMapping("/resetpw")
	public void resetpw(HttpServletRequest request) throws Exception{
		service.ResetPw(request);
	}
}
