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
	
	@RequestMapping("/login")
	public String login(HttpServletRequest request, Model model) throws Exception{
		service.Login(request, model);
		return "userlogin";
	}

}
