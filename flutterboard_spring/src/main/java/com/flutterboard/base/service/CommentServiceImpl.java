package com.flutterboard.base.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.flutterboard.base.dao.CommentDao;
import com.flutterboard.base.dto.CommentDto;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class CommentServiceImpl implements CommentService {
	
	@Autowired
	CommentDao dao;

	@Override
	public void ShowComment(HttpServletRequest request, Model model) throws Exception {
		int boardid=Integer.parseInt(request.getParameter("boardid"));
		
		List<CommentDto> dtos = dao.ShowComment(boardid);
		
		JSONObject jsonList = new JSONObject();
	    JSONArray itemList = new JSONArray();
	    
	    for (int i=0;i<dtos.size();i++) {
            JSONObject tempJson = new JSONObject();
            tempJson.put("c_userid", dtos.get(i).getC_userid());
            tempJson.put("username", dtos.get(i).getUsername());
            tempJson.put("commentcontent", dtos.get(i).getCommentcontent());
            tempJson.put("commentwritedate", dtos.get(i).getCommentwritedate());
            tempJson.put("updatedate", dtos.get(i).getCommentupdatedate());
            itemList.add(tempJson);
	    }
		
	    jsonList.put("results",itemList);
	    model.addAttribute("ITEM",jsonList.toJSONString());
	}

}
