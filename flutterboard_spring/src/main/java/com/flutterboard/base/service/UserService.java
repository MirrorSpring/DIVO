package com.flutterboard.base.service;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import jakarta.servlet.http.HttpServletRequest;

@Service
public interface UserService {
	
	public void Login(HttpServletRequest request, Model model) throws Exception;

}
