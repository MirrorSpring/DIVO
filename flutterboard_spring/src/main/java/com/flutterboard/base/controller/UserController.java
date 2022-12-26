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
	public void resetpw(HttpServletRequest request) throws Exception {
		service.ResetPw(request);
	}

	// Desc: 회원가입
	// Date: 2022-12-26
	@RequestMapping("/join")
	public void Join(HttpServletRequest request) throws Exception{
		service.Join(request);
	}
	
	//Desc: ID 중복확인
	//Date: 2022-12-26
	@RequestMapping("/idcheck")
	public String IDCheck(HttpServletRequest request, Model model) throws Exception{
		service.IDCheck(request, model);
		
		return "result";
	}
	
	// Desc: 회원정보 출력
	// Date: 2022-12-26
	@RequestMapping("/mypage")
	public String MyPage(HttpServletRequest request, Model model) throws Exception{
		service.MyPage(request, model);
		return "result";
	}
	
	//Desc: 회원정보 수정
	//Date: 2022-12-26
	@RequestMapping("/updateuser")
	public void UpdateUser(HttpServletRequest request) throws Exception{
		service.UpdateUser(request);
	}
}
