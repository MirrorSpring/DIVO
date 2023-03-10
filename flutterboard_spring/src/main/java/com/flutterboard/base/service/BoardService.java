package com.flutterboard.base.service;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import jakarta.servlet.http.HttpServletRequest;

@Service
public interface BoardService {

	public void ShowMain(HttpServletRequest request, Model model) throws Exception;
	public void BoardDetail(HttpServletRequest request, Model model) throws Exception;
	public void Write(HttpServletRequest request) throws Exception;
	public void UpdateBoard(HttpServletRequest request) throws Exception;
	public void DeleteBoard(HttpServletRequest request) throws Exception;
}
