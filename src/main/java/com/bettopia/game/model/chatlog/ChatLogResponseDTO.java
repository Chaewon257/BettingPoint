package com.bettopia.game.model.chatlog;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatLogResponseDTO {
	private List<ChatLogDTO> logs;
    private int total;
}
