package com.flutterboard.base.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.flutterboard.base.dao.BoardDao;
import com.flutterboard.base.dto.BoardDto;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDao dao;

	//Desc: 메인화면 출력
	//Date: 2022-12-25
	@Override
	public void ShowMain(Model model) throws Exception {
		List<BoardDto> dtos=dao.ShowMain();
		
	    JSONObject jsonList = new JSONObject();
	    JSONArray itemList = new JSONArray();
	    
	    for (int i=0;i<dtos.size();i++) {
            JSONObject tempJson = new JSONObject();
            tempJson.put("boardid", dtos.get(i).getBoardid());
            tempJson.put("writername", dtos.get(i).getUsername());
            tempJson.put("writerid", dtos.get(i).getWriterid());
            tempJson.put("title", dtos.get(i).getTitle());
            tempJson.put("title", dtos.get(i).getTitle());
            tempJson.put("writedate", dtos.get(i).getWritedate());
            tempJson.put("updatedate", dtos.get(i).getUpdatedate());
            itemList.add(tempJson);
	    }
		
	    jsonList.put("results",itemList);
	    model.addAttribute("ITEM",jsonList.toJSONString());
	}

}
