package com.bettopia.game.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.bettopia.game.model.board.BoardResponseDTO;
import com.bettopia.game.model.board.BoardService;


@RestController
@RequestMapping("/api/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    // 게시글 목록 조회 
    @GetMapping("/boardlist")
    public List<BoardResponseDTO.BoardDTO> list() {
        return boardService.getAllBoards();
    }

    // 게시글 상세보기 
    @GetMapping("/boarddetail")
    public BoardResponseDTO.BoardDTO getBoardDetail(@RequestParam String uid) {
        return boardService.getBoardByUid(uid);
    }

    // 게시글 등록 (로그인한 사용자만 가능)
    @PostMapping("/boardinsert")
    public void insertBoard(@RequestBody BoardResponseDTO.InsertBoardResponseDTO dto, HttpSession session) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }

        dto.setUser_uid(loginUser.getUser_uid());
        boardService.insertBoard(dto);
    }

    // 게시글 수정 (로그인 && 본인 글만 가능)
    @PutMapping("/boardupdate")
    public void updateBoard(@RequestBody BoardResponseDTO.BoardDTO dto, HttpSession session) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }

        BoardResponseDTO.BoardDTO existingBoard = boardService.getBoardByUid(dto.getUid());
        if (!loginUser.getUser_uid().equals(existingBoard.getUser_uid())) {
            throw new RuntimeException("본인만 수정할 수 있습니다.");
        }

        dto.setUser_uid(loginUser.getUser_uid()); // 방어코드
        boardService.updateBoard(dto);
    }

    // 게시글 삭제 (로그인 && 본인 글만 가능)
    @DeleteMapping("/boarddelete")
    public void deleteBoard(@RequestParam String uid, HttpSession session) {
        UserDTO loginUser = (UserDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }

        BoardResponseDTO.BoardDTO existingBoard = boardService.getBoardByUid(uid);
        if (!loginUser.getUser_uid().equals(existingBoard.getUser_uid())) {
            throw new RuntimeException("본인만 삭제할 수 있습니다.");
        }

        boardService.deleteBoard(uid);
    }
}
