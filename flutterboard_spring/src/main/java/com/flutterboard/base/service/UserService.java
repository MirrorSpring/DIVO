package com.flutterboard.base.service;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import jakarta.servlet.http.HttpServletRequest;

@Service
public interface UserService {

	public void Login(HttpServletRequest request, Model model) throws Exception;

	public void FindId(HttpServletRequest request, Model model) throws Exception;

	public void FindPw(HttpServletRequest request, Model model) throws Exception;
	
	public void ResetPw(HttpServletRequest request) throws Exception;
	
//	public void Join(HttpServletRequest request) throws Exception;
	
	public void Join(HttpServletRequest request) throws Exception;
	
	public void IDCheck(HttpServletRequest request, Model model) throws Exception;

}
