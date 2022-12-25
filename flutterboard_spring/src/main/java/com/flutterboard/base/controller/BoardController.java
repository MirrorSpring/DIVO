package com.flutterboard.base.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.flutterboard.base.service.BoardService;

@Controller
public class BoardController {
	
	@Autowired
	BoardService service;

	@RequestMapping("/main")
	public String ShowMain(Model model) throws Exception{
		service.ShowMain(model);
		return "showmain";
	}
}
