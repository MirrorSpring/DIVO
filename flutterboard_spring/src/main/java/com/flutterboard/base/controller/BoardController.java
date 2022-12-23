package com.flutterboard.base.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.flutterboard.base.service.BoardService;

@Controller
public class BoardController {

	@Autowired
	BoardService service;
}
