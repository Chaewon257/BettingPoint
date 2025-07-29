-- user
CREATE TABLE user (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '고유 식별자',
  user_name VARCHAR(50) NOT NULL COMMENT '사용자 이름',
  password VARCHAR(100) NOT NULL COMMENT '비밀번호',
  nickname VARCHAR(100) NOT NULL COMMENT '서비스 내 닉네임',
  email VARCHAR(100) NOT NULL UNIQUE COMMENT '로그인 ID',
  birth_date DATE COMMENT '생년월일',
  phone_number VARCHAR(30) UNIQUE COMMENT '전화번호',
  agree_privacy BOOLEAN DEFAULT FALSE COMMENT '개인정보 동의 여부',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
  updated_at DATETIME DEFAULT NULL COMMENT '수정일',
  last_login_at DATETIME DEFAULT NULL COMMENT '마지막 로그인 시간',
  role VARCHAR(50) DEFAULT 'USER' COMMENT '권한',
  point_balance INT UNSIGNED DEFAULT 0 COMMENT '보유 포인트',
  profile_img VARCHAR(255) DEFAULT '' COMMENT '프로필 이미지 경로'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- auth_token
CREATE TABLE auth_token (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '고유 식별자',
  user_uid CHAR(32) NOT NULL COMMENT '로그인한 사용자',
  refresh_token VARCHAR(200) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '토큰 생성 시간',
  UNIQUE KEY unique_user_uid (user_uid),
  FOREIGN KEY (user_uid) REFERENCES user(uid)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- game
CREATE TABLE game (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '게임 고유 식별자',
  name VARCHAR(255) NOT NULL COMMENT '게임 이름',
  type VARCHAR(50) NOT NULL COMMENT '게임 유형: SINGLE(개인), MULTI(단체)',
  description TEXT COMMENT '게임 설명',
  game_img VARCHAR(255) DEFAULT '' COMMENT '게임 이미지 경로',
  status VARCHAR(50) DEFAULT 'ACTIVE' COMMENT '사용 가능 여부 (ACTIVE, INACTIVE)',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '생성일'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- game_history
CREATE TABLE game_history (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '게임 참여 이력 고유 식별자',
  user_uid CHAR(32) NOT NULL COMMENT '참여한 사용자',
  game_uid CHAR(32) NOT NULL COMMENT '어떤 게임인지 확인',
  betting_amount INT NOT NULL COMMENT '배팅 포인트',
  game_result VARCHAR(20) COMMENT 'WIN / LOSE',
  point_value INT COMMENT '배당 포인트',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '게임 결과 기록 시간',
  FOREIGN KEY (user_uid) REFERENCES user(uid),
  FOREIGN KEY (game_uid) REFERENCES game(uid)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- point_history
CREATE TABLE point_history (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '고유 식별자',
  user_uid CHAR(32) NOT NULL COMMENT '어떤 사용자의 포인트 기록인지 확인',
  type VARCHAR(50) NOT NULL COMMENT 'CHARGE(충전), USE(사용), WIN(승리), LOSE(패배)',
  amount INT NOT NULL COMMENT '변화된 포인트 양',
  balance_after INT NOT NULL COMMENT '거래 후 사용자의 잔액',
  gh_uid CHAR(32) DEFAULT NULL COMMENT '포인트 변화에 대한 게임 Data ID',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '기록 생성 시간',
  FOREIGN KEY (user_uid) REFERENCES user(uid),
  FOREIGN KEY (gh_uid) REFERENCES game_history(uid)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- game_level
CREATE TABLE game_level (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '게임 난이도 고유 식별자',
  game_uid CHAR(32) NOT NULL COMMENT '게임 UID',
  level VARCHAR(50) NOT NULL COMMENT '난이도',
  probability DOUBLE NOT NULL COMMENT '확률',
  reward DOUBLE NOT NULL COMMENT '배당',
  FOREIGN KEY (game_uid) REFERENCES game(uid)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- game_room
CREATE TABLE game_room (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '게임방 고유 식별자',
  game_level_uid CHAR(32) NOT NULL COMMENT '어떤 게임-난이도인지 확인',
  host_uid CHAR(32) NOT NULL COMMENT '방 생성자 (주최자)',
  title VARCHAR(255) COMMENT '방 제목 또는 설명',
  min_bet INT DEFAULT 0 COMMENT '최소 배팅 포인트',
  status VARCHAR(50) DEFAULT 'WAITING' COMMENT 'WAITING / PLAYING / CLOSED',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '방 생성 시간',
  started_at DATETIME COMMENT '게임 시작 시간',
  FOREIGN KEY (game_level_uid) REFERENCES game_level(uid),
  FOREIGN KEY (host_uid) REFERENCES user(uid)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- board
CREATE TABLE board (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '게시글 고유 식별자',
  user_uid CHAR(32) NOT NULL COMMENT '작성자',
  title VARCHAR(255) NOT NULL COMMENT '게시글 제목',
  content TEXT NOT NULL COMMENT '게시글 내용',
  category VARCHAR(50) DEFAULT 'FREE' COMMENT '게시판 구분: FREE, REVIEW, NOTICE 등',
  view_count INT DEFAULT 0 COMMENT '조회수',
  like_count INT DEFAULT 0 COMMENT '좋아요수',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
  updated_at DATETIME COMMENT '수정일',
  board_img VARCHAR(255) DEFAULT '' COMMENT '이미지',
  FOREIGN KEY (user_uid) REFERENCES user(uid)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- chat_logs
CREATE TABLE chat_logs (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '챗봇 대화 ID',
  user_uid CHAR(32) NOT NULL COMMENT '회원번호',
  title VARCHAR(255) NOT NULL COMMENT '문의 내역 제목',
  question TEXT NOT NULL COMMENT '질문',
  response TEXT COMMENT '응답',
  chat_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '질문 등록 일시',
  response_date DATETIME COMMENT '관리자 응답 일시',
  FOREIGN KEY (user_uid) REFERENCES user(uid)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- chatbot_qa
CREATE TABLE chatbot_qa (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '챗봇 질문답변 UID',
  main_category VARCHAR(50) NOT NULL COMMENT '대분류',
  sub_category VARCHAR(50) DEFAULT NULL COMMENT '소분류',
  question_text VARCHAR(255) NOT NULL COMMENT '사용자 질문',
  answer_text TEXT NOT NULL COMMENT '챗봇 답변'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- banner
CREATE TABLE banner (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '컨텐츠 ID',
  title VARCHAR(255) NOT NULL COMMENT '배너 제목',
  image_path VARCHAR(255) COMMENT '이미지 경로(S3)',
  banner_link_url VARCHAR(255) COMMENT '배너 클릭 URL',
  description TEXT COMMENT '배너 설명',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- bettube
CREATE TABLE bettube (
  uid CHAR(32) NOT NULL PRIMARY KEY COMMENT '베튜브 ID',
  title TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '베튜브 제목',
  bettube_url VARCHAR(255) COMMENT '영상 유튜브 URL',
  description TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '영상 설명',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록일'
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- email_verification
CREATE TABLE email_verification (
  email VARCHAR(100) PRIMARY KEY,
  verification_code VARCHAR(6),
  expired_at DATETIME,
  is_verified BOOLEAN DEFAULT FALSE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE payment ( 
uid VARCHAR(36) PRIMARY KEY COMMENT 'payment_uid, UUID 기반 PK', 
pay_type VARCHAR(20) COMMENT '결제 수단 (카드, 계좌 등)', 
amount INT NOT NULL COMMENT '결제 금액', 
order_uid VARCHAR(50) NOT NULL UNIQUE COMMENT '가맹점 주문 UID', 
order_name VARCHAR(255) COMMENT '주문명', 
user_uid VARCHAR(36) NOT NULL COMMENT '결제 사용자 UID', 
payment_key VARCHAR(100) UNIQUE COMMENT '토스페이먼츠 payment_key', 
status ENUM('PENDING', 'PAID', 'FAILED', 'CANCELED') DEFAULT 'PENDING' COMMENT '결제 상태', 
created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '결제 생성 시각', 
approve_at DATETIME NULL COMMENT '결제 승인 시각', 
failure_reason VARCHAR(500) COMMENT '결제 실패 사유', 
receipt_url VARCHAR(500) COMMENT '토스페이먼츠 영수증 URL', 
CONSTRAINT fk_payment_user_uid FOREIGN KEY (user_uid) REFERENCES user(uid) ON DELETE CASCADE ON UPDATE CASCADE 
); 
