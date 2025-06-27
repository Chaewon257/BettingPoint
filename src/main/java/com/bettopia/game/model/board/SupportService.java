package com.bettopia.game.model.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class SupportService {
	
	@Autowired
	@Qualifier("supportDAO")
	SupportDAOMybatis supportDAO;

	public List<BoardDTO> selectByCategory (String category) {
		return supportDAO.selectByCategory(category);
	}
	
	public BoardDTO selectById(String boardId) {
		return supportDAO.selectById(boardId);
	}
	
}
