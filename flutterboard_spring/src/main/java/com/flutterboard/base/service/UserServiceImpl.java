package com.flutterboard.base.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.flutterboard.base.dao.UserDao;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserDao dao;

	// Desc: 로그인
	// Date: 2022-12-25
	@Override
	public void Login(HttpServletRequest request, Model model) throws Exception {
		String userid = request.getParameter("userid");
		String userpw = request.getParameter("userpw");

		int check = dao.Login(userid, userpw);

		JSONObject jsonList = new JSONObject();
		JSONArray itemList = new JSONArray();
		JSONObject tempJson = new JSONObject();
		tempJson.put("check", check);
		itemList.add(tempJson);
		jsonList.put("results", itemList);
		model.addAttribute("CHECK", jsonList.toJSONString());
	}

	// Desc: ID 찾기
	// Date: 2022-12-25
	@Override
	public void FindId(HttpServletRequest request, Model model) throws Exception {
		String username = request.getParameter("username");
		String birthday = request.getParameter("birthday");
		JSONObject jsonList = new JSONObject();
		JSONArray itemList = new JSONArray();

		List<String> userid = dao.FindId(username, birthday);

		for (int i = 0; i < userid.size(); i++) {
			JSONObject tempJson = new JSONObject();
			tempJson.put("userid", userid.get(i));
			itemList.add(tempJson);
		}

		jsonList.put("results", itemList);
		model.addAttribute("ITEM", jsonList.toJSONString());
	}

	// Desc: 비밀번호 찾기
	// Date: 2022-12-26
	@Override
	public void FindPw(HttpServletRequest request, Model model) throws Exception {
		String userid = request.getParameter("userid");
		String username = request.getParameter("username");
		String birthday = request.getParameter("birthday");
		int check = dao.FindPw(username, userid, birthday);

		JSONObject jsonList = new JSONObject();
		JSONArray itemList = new JSONArray();

		JSONObject tempJson = new JSONObject();
		tempJson.put("check", check);
		itemList.add(tempJson);

		jsonList.put("results", itemList);
		model.addAttribute("ITEM", jsonList.toJSONString());
	}

	//Desc: 비밀번호 재설정
	//Date: 2022-12-26
	@Override
	public void ResetPw(HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		String userpw=request.getParameter("userpw");
		String userid=request.getParameter("userid");
		
		dao.ResetPw(userpw, userid);
	}

}
