package com.flutterboard.base.service;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import jakarta.servlet.http.HttpServletRequest;

@Service
public interface BoardService {

	public void ShowMain(Model model) throws Exception;
	public void BoardDetail(HttpServletRequest request, Model model) throws Exception;
}
