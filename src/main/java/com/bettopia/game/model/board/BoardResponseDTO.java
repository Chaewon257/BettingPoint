package com.bettopia.game.model.board;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
public class BoardResponseDTO {
	/** 한 페이지에 담긴 게시글 목록 */
    private List<BoardDTO> boards;
    /** 현재 페이지 번호 (1부터 시작) */
    private int currentPage;
    /** 페이지당 게시글 수 */
    private int pageSize;
    /** 전체 게시글 건수 */
    private long totalCount;
    /** 전체 페이지 수 */
    private int totalPages;
    /** (선택) 요청한 카테고리 */
    private String category;

}
