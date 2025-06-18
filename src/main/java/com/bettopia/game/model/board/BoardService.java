package com.bettopia.game.model.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bettopia.game.model.board.BoardRequestDTO.InsertBoardRequestDTO;
import com.bettopia.game.model.board.BoardRequestDTO.UpdateBoardRequestDTO;
import com.bettopia.game.model.board.BoardResponseDTO.BoardDTO;

@Service
public class BoardService {
    
    @Autowired
    private BoardDAOInterface boardDAO;
    
    //게시글 목록 조회
    public List<BoardResponseDTO> getAllBoards() {
        return boardDAO.selectAll();
    }
    //게시글 등록
    public void insertBoard(InsertBoardRequestDTO dto, String user_uid) {
        BoardDTO board = BoardDTO.builder()
                .title(dto.getTitle())
                .content(dto.getContent())
                .category(dto.getCategory())
                .board_img(dto.getBoard_img())
                .user_uid(user_uid)
                .build();
        boardDAO.insertBoard(board);
    }
    //게시글 상세 조회
    public BoardResponseDTO getBoardByUid(String uid) {
        return boardDAO.getBoardByUid(uid);
    }
    //게시글 수정
    public void updateBoard(String uid, UpdateBoardRequestDTO dto, String user_uid) {
        BoardDTO board = BoardDTO.builder()
                .uid(uid)
                .content(dto.getContent())
                .category(dto.getCategory())
                .board_img(dto.getBoard_img())
                .user_uid(user_uid) // 수정 방어코드
                .build();
        boardDAO.updateBoard(board);
    }
    //게시글 삭제
    public void deleteBoard(String uid) {
        boardDAO.deleteBoard(uid);
    }

    

   
}
