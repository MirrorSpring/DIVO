package com.flutterboard.base.service;

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

	@Override
	public void Login(HttpServletRequest request, Model model) throws Exception {
		String userid=request.getParameter("userid");
		String userpw=request.getParameter("userpw");
		
		int check=dao.Login(userid, userpw);
		
	    JSONObject jsonList = new JSONObject();
	    JSONArray itemList = new JSONArray();
        JSONObject tempJson = new JSONObject();
        tempJson.put("check", check);
        itemList.add(tempJson);
	    jsonList.put("results",itemList);
	    model.addAttribute("CHECK",jsonList.toJSONString());
	}

}
