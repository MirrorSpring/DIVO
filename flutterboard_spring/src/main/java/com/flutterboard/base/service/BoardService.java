package com.flutterboard.base.service;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public interface BoardService {

	public void ShowMain(Model model) throws Exception;
}
