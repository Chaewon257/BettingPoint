package com.bettopia.game.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.bettopia.game.model.board.BoardDTO;
import com.bettopia.game.model.board.SupportService;

@RestController
@RequestMapping("/api/support")
public class SupportRestController {
	
	@Autowired
	private SupportService supportService;

	@GetMapping("/list/{category}")
    public Object getBoardsByCategory(@PathVariable String category,
            						  @RequestParam(required = false, defaultValue = "1") int page) {

        String upperCategory = category.toUpperCase();

        if (upperCategory.equals("NOTICE")) {
            int size = 10;
            int offset = (page - 1) * size;

            List<BoardDTO> list = supportService.selectByCategoryWithPaging(upperCategory, offset, size);
            int total = supportService.countByCategory(upperCategory);
            
            Map<String, Object> result = new HashMap<>();
            result.put("notices", list);
            result.put("total", total);
            return result;

        } else {
            // FAQ 또는 기타 카테고리는 전체 리스트 반환
            return supportService.selectByCategory(upperCategory);
        }
    }

    @GetMapping("/detail/{boardId}")
    public BoardDTO selectById(@PathVariable String boardId) {
        return supportService.selectById(boardId);
    }
    
}
