package com.flutterboard.base.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.flutterboard.base.dao.BoardDao;
import com.flutterboard.base.dto.BoardDto;

import jakarta.servlet.http.HttpServletRequest;

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
            tempJson.put("writedate", dtos.get(i).getWritedate());
            tempJson.put("updatedate", dtos.get(i).getBoardupdatedate());
            itemList.add(tempJson);
	    }
		
	    jsonList.put("results",itemList);
	    model.addAttribute("ITEM",jsonList.toJSONString());
	}

	//Desc: 게시글 상세보기 출력
	//Date: 2022-12-25
	@Override
	public void BoardDetail(HttpServletRequest request, Model model) throws Exception {
		int boardid=Integer.parseInt(request.getParameter("boardid"));
		BoardDto dto=dao.BoardDetail(boardid);
		
	    JSONObject jsonList = new JSONObject();
	    JSONArray itemList = new JSONArray();
	    
        JSONObject tempJson = new JSONObject();
        tempJson.put("writername", dto.getUsername());
        tempJson.put("writerid", dto.getWriterid());
        tempJson.put("title", dto.getTitle());
        tempJson.put("writedate", dto.getWritedate());
        tempJson.put("updatedate", dto.getBoardupdatedate());
        tempJson.put("content", dto.getContent());
        itemList.add(tempJson);
        
	    jsonList.put("results",itemList);
	    model.addAttribute("ITEM",jsonList.toJSONString());
		
	}

	//Desc: 게시글 쓰기
	//Date: 2022-12-25
	@Override
	public void Write(HttpServletRequest request) throws Exception {
		String writerid=request.getParameter("writerid");
		String title=request.getParameter("title");
		String content=request.getParameter("content");
		
		dao.Write(writerid, title, content);
		
	}

	//Desc: 게시글 수정
	//Date: 2022-12-25
	@Override
	public void UpdateBoard(HttpServletRequest request) throws Exception {
		String title=request.getParameter("title");
		String content=request.getParameter("content");
		int boardid=Integer.parseInt(request.getParameter("boardid"));
		
		dao.UpdateBoard(title, content, boardid);
		
	}

}
