package com.flutterboard.base.service;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import jakarta.servlet.http.HttpServletRequest;

@Service
public interface CommentService {

	public void ShowComment(HttpServletRequest request, Model model) throws Exception;
	
	public void UpdateComment(HttpServletRequest request) throws Exception;
	
	public void DeleteComment(HttpServletRequest request) throws Exception;
	
	public void Comment(HttpServletRequest request) throws Exception;

}
