-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: betting
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_token`
--

DROP TABLE IF EXISTS `auth_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_token` (
  `uid` char(32) NOT NULL COMMENT '고유 식별자',
  `user_uid` char(32) NOT NULL COMMENT '로그인한 사용자',
  `refresh_token` varchar(200) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '토큰 생성 시간',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `user_uid` (`user_uid`),
  CONSTRAINT `auth_token_ibfk_1` FOREIGN KEY (`user_uid`) REFERENCES `user` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `banner`
--

DROP TABLE IF EXISTS `banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banner` (
  `uid` char(32) NOT NULL COMMENT '컨텐츠 ID',
  `title` varchar(255) NOT NULL COMMENT '배너 제목',
  `image_path` varchar(255) DEFAULT NULL COMMENT '이미지 경로(S3)',
  `banner_link_url` varchar(255) DEFAULT NULL COMMENT '배너 클릭 URL',
  `description` text COMMENT '배너 설명',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner`
--

LOCK TABLES `banner` WRITE;
/*!40000 ALTER TABLE `banner` DISABLE KEYS */;
INSERT INTO `banner` VALUES ('79b07b8cac414bc99bf0845c2680b6e6','배너 1','af89df9d-4a19-450c-9c0c-07a744a12fd7.png','http://bettopia.dustbox.kr/support?uid=9b846a27dbe6436aaf3180780972f057','배너 2','2025-07-05 14:33:06'),('9251d40f2fcb4ea5b88907ce1448f0c0','배너 3','ebdcbfaf-4dc9-4cd2-9979-a0fa00cc0ac8.png','http://bettopia.dustbox.kr/gameroom','배너 4','2025-07-03 12:16:42'),('b6e888e3d14241cfa42d7242c85956b7','배너 2','12c702fc-5615-4e77-8ca1-976bb4683e18.png','http://bettopia.dustbox.kr/support?uid=9b846a27dbe6436aaf3180780972f057','배너 1','2025-07-04 11:45:11'),('ef322f5c3b6e43879691806e1b2343e2','배너 4','f23381cf-3e03-4e0f-9320-1ceefc330bbc.png','http://bettopia.dustbox.kr/solo','배너 3','2025-07-03 09:36:50');
/*!40000 ALTER TABLE `banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bettube`
--

DROP TABLE IF EXISTS `bettube`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bettube` (
  `uid` char(32) NOT NULL COMMENT '베튜브 ID',
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `bettube_url` varchar(255) DEFAULT NULL COMMENT '영상 유튜브 URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bettube`
--

LOCK TABLES `bettube` WRITE;
/*!40000 ALTER TABLE `bettube` DISABLE KEYS */;
INSERT INTO `bettube` VALUES ('04f6508658a64696969bcadc0d281ac3','여름 이벤트 합니다~','https://www.youtube.com/watch?v=q5klcVaaNCI&list=RDq5klcVaaNCI&start_radio=1','✨이벤트 많관부','2025-07-03 22:11:18'),('1833e74a7f994f049dd9558dbc05a7a5','플레이리스트 추천','https://www.youtube.com/watch?v=87Ts6GMqy8M&list=RD87Ts6GMqy8M&start_radio=1&t=1s','여름 맞이 플레이리스트 추천드립니다~','2025-07-04 22:31:18'),('31d80051abe840a599f3022a01e0cf39','Treasure Hunt 게임 소개','https://www.youtube.com/watch?v=Rk_ddOG5JjA','Treasure Hunt 게임 소개 영상입니다~','2025-07-08 17:38:01'),('5ba714ff0aad4d5c87449bc8ab322b34','Turtle Run 소개 영상','https://www.youtube.com/watch?v=fe-C57gOjqw','Turtle Run 게임 소개 영상입니다~','2025-07-08 17:38:54'),('b10ca9168d8d41afbdbf1053e0f55f92','☁️','https://www.youtube.com/watch?v=fdILKBqjzXU&list=PLK56k6RAxC3bfOzZTjN-EIE-X7R7x81yj&index=4','게임 실패시 이 영상을 보세요?','2025-07-02 22:41:18'),('e7e9b21ec6ca41d0af2d3373b2fdb3db','?','https://www.youtube.com/watch?v=k4lisZ6yAEk&list=PLK56k6RAxC3bfOzZTjN-EIE-X7R7x81yj&index=14','이 영상을 보면 행복해집니다??','2025-07-03 09:47:25'),('ea1c601d75554377a37c51f6da15fc06','Coin Toss 게임 소개','https://www.youtube.com/watch?v=zgoFJxIvz0s','Coin Toss 게임 소개 영상입니다~','2025-07-08 17:38:34');
/*!40000 ALTER TABLE `bettube` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `uid` char(32) NOT NULL COMMENT '게시글 고유 식별자',
  `user_uid` char(32) NOT NULL COMMENT '작성자',
  `title` varchar(255) NOT NULL COMMENT '게시글 제목',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `category` varchar(50) DEFAULT 'FREE' COMMENT '게시판 구분: FREE, REVIEW, NOTICE 등',
  `view_count` int DEFAULT '0' COMMENT '조회수',
  `like_count` int DEFAULT '0' COMMENT '좋아요수',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
  `updated_at` datetime DEFAULT NULL COMMENT '수정일',
  `board_img` varchar(255) DEFAULT NULL COMMENT '이미지',
  PRIMARY KEY (`uid`),
  KEY `user_uid` (`user_uid`),
  CONSTRAINT `board_ibfk_1` FOREIGN KEY (`user_uid`) REFERENCES `user` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chat_logs`
--

DROP TABLE IF EXISTS `chat_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_logs` (
  `uid` char(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '챗봇 대화 ID',
  `user_uid` char(32) COLLATE utf8mb4_general_ci NOT NULL COMMENT '회원번호',
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT '문의 내역 제목',
  `question` mediumtext COLLATE utf8mb4_general_ci NOT NULL COMMENT '질문',
  `response` mediumtext COLLATE utf8mb4_general_ci COMMENT '응답',
  `chat_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '질문 등록 일시',
  `response_date` datetime DEFAULT NULL COMMENT '관리자 응답 일시',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `chatbot_qa`
--

DROP TABLE IF EXISTS `chatbot_qa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_qa` (
  `uid` char(32) NOT NULL COMMENT '챗봇 질문답변 UID',
  `main_category` varchar(50) NOT NULL COMMENT '대분류 (예: GAME, POINT, ETC)',
  `sub_category` varchar(50) DEFAULT NULL COMMENT '소분류 (예: 게임 규칙, 충전 방법 등)',
  `question_text` varchar(255) NOT NULL COMMENT '사용자 질문',
  `answer_text` text NOT NULL COMMENT '챗봇 답변',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_qa`
--

LOCK TABLES `chatbot_qa` WRITE;
/*!40000 ALTER TABLE `chatbot_qa` DISABLE KEYS */;
INSERT INTO `chatbot_qa` VALUES ('02df613876a149e0bcc788cc3e8d4c5c','GAME','INFO','한 번에 여러 게임에 동시에 참여할 수 있나요?','아쉽게도 현재는 여러 게임에 동시에 참여하실 수 없습니다.\n하나의 게임이 종료된 후, 다음 게임에 참여해 주세요.'),('0452e316db884ce39fa03b905ac42852','GAME','INFO','게임은 하루에 몇 번까지 참여할 수 있나요?','하루 동안 게임 참여 횟수에는 제한이 없습니다.\n원하시는 만큼 자유롭게 게임에 참여하실 수 있어요!'),('0cf38ae8fa8745e281a22114fe737b19','ETC','SYSTEM','지원되는 브라우저나 OS가 따로 있나요?','기본적으로 모든 기기와 브라우저를 지원하지만,\n일부 기능은 모바일 화면에서 제한되거나 최적화가 덜 되어 있을 수 있습니다.\nPC 환경에서 접속 시 가장 안정적으로 사이트를 이용하실 수 있습니다.'),('1615e6a008e9457d883bba06fa2e8fe6','GAME','INFO','게임 시작 전에 참가 인원 제한이 있나요?','네, 단체 게임의 경우 최소 2명에서 최대 8명까지 함께 참여하실 수 있습니다.\n또한, 게임방 상태가 대기 중인(waiting) 경우에만 참여가 가능하며, 이미 진행 중인(playing) 방에는 입장하실 수 없습니다.'),('191a23e4d67d4f889ea0e2da12d28ce6','ETC','ACCOUNT','이메일이나 전화번호를 변경하고 싶어요.','현재는 이메일과 전화번호 등 개인정보 수정은 불가능하며, 비밀번호만 변경이 가능합니다.\n정보 수정을 원하시는 경우, [고객지원] > [1:1 문의]를 통해 요청해 주세요.'),('1ecbca05617248cc95f7d8361a3e55f5','GAME','RULE','승률 통계는 게임 룰에 영향을 주나요?','아니요, 개인 승률은 게임 룰이나 결과에 영향을 주지 않습니다.\n각 게임은 설정된 난이도에 따라 확률과 배당률이 달라지며, 이는 모두 사전에 정의된 기준에 따라 공정하게 적용됩니다.\n해당 기준은 [게임소개]에서 확인 가능합니다.'),('2201afffa155476eb907a3b05741d8eb','ETC','SYSTEM','로그인에 계속 실패해요. 어떻게 해야 하나요?','로그인 오류가 지속되는 경우, [고객지원] > [1:1 문의]를 통해 상황을 남겨주시면 확인 후 빠르게 도와드리겠습니다.'),('30c3398a9c704b628ef00a36cde6f1df','GAME','INFO','게임 참여 전에 포인트 잔액을 꼭 확인해야 하나요?','게임 내에서 포인트 잔액은 확인 가능하지만,\n충전은 메인페이지 또는 마이페이지에서만 가능하니 미리 확인해두시는 걸 추천드립니다.'),('44b18a00c49f4e48ba09e65ff5fd3151','ETC','ACCOUNT','회원가입 시 인증 절차가 있나요?','네, 회원가입 시 이메일 인증 절차를 거쳐야 가입이 완료됩니다.\n정확한 이메일을 입력해 주세요.'),('491170367224486bace47936af29068d','GAME','RULE','연속 배팅 시 룰이나 제한이 따로 있나요?','게임 종류에 따라 다를 수 있습니다.\n개인 게임의 경우 최초 베팅 금액은 수정이 불가능하며,\n단체 게임의 경우 \'게임 준비\' 상태를 해제해야 베팅 금액 수정이 가능합니다.'),('4ba096c07d30401bba624006423e1c4a','ETC','SYSTEM','게임이 자꾸 끊기거나 멈춰요.','원활한 이용을 위해 PC 환경의 Chrome 또는 Edge 브라우저 사용을 권장드리며,\n문제가 지속될 경우 [고객지원 > 1:1 문의]에 상세 내용을 남겨주시면 확인 후 안내해 드리겠습니다.'),('5d1ebd29bab043458be790b53e4b1888','POINT','POINT','충전한 포인트는 바로 사용 가능한가요?','네, 충전된 포인트는 즉시 사용 가능합니다.\n다만 현재는 사이트 내 게임 베팅 용도로만 사용 가능하며,\n추후에는 포인트를 현금처럼 사용할 수 있는 기능도 준비 중입니다.'),('74d160475c364e959d6a76c848ae9355','GAME','INFO','모바일에서도 동일한 방식으로 게임을 이용할 수 있나요?','네, 모바일 웹사이트 접속을 통해 게임 이용이 가능합니다.\n다만, 일부 기능은 모바일 환경에서 제한될 수 있으니 원활한 이용을 위해서는 PC 이용을 권장드립니다.'),('78343540c25846caaa1a95436069c09f','ETC','ACCOUNT','계정을 탈퇴하려면 어떻게 해야 하나요?','현재 계정 탈퇴 기능은 준비 중에 있습니다.\n추후 별도 공지를 통해 이용 방법을 안내드릴 예정입니다.'),('7839139d98854eabb3377abc93875720','ETC','SYSTEM','시스템 점검 중에는 어떤 기능이 제한되나요?','시스템 점검이 진행되는 동안에는 게임 참여, 포인트 충전, 게시글 작성 등 일부 기능의 이용이 제한됩니다.\n자세한 점검 일정은 [고객지원 > 공지사항]을 확인해 주세요.'),('7ef676697728405b995c5edb6bd990a5','POINT','POINT','포인트를 다른 계정으로 옮길 수 있나요?','타 계정으로 포인트를 전송하거나 양도하는 기능은 제공되지 않습니다.\n모든 포인트는 회원 본인 계정에서만 사용 가능합니다.'),('9376b757a9b4427ab4462ccfef5445a1','ETC','ACCOUNT','아이디나 닉네임은 중복으로 생성할 수 있나요?','아이디와 닉네임은 각각 고유하게 생성되며, 중복 등록은 불가능합니다.\n이미 사용 중인 아이디나 닉네임은 등록할 수 없습니다.'),('a1ee4fee0ca24bf295490a90c29ca320','POINT','POINT','포인트 충전은 무료인가요?','포인트 충전시 수수료 10%가 자동 차감/결제 됩니다.'),('a402e70259f34304bae2cbd998d62954','ETC','SYSTEM','업데이트나 패치가 있을 때 어디서 확인하나요?','업데이트 및 패치 관련 안내는 [고객지원 > 공지사항] 게시판을 통해 공지됩니다.\n변경사항이 있을 경우 꼭 확인해 주세요.'),('a772641eef6341fab7b5eebc46a27d1d','POINT','POINT','충전 가능한 최소 금액이나 단위가 정해져 있나요?','최소 충전 금액에 대한 제한은 없지만, 100원 단위로만 충전이 가능합니다.\n예: 100원, 500원, 1,000원 등'),('bd0920cb2d304c92a9decbbe43b705aa','GAME','RULE','룰 위반 시 자동으로 게임에서 탈락되나요?','게임 종류에 따라 처리 방식이 상이합니다.\n자세한 사항은 [고객지원] > [FAQ] 또는 [공지사항] 게시판을 통해 확인해 주세요.'),('cd094acd50924ffda35e473a31c29d8b','POINT','POINT','포인트로 상품을 구매하거나 교환할 수 있나요?','해당 기능은 현재 준비 중에 있으며,\n추후 업데이트를 통해 다양한 사용처가 추가될 예정입니다.'),('d70daac533a8498ab1a603eea039e67d','POINT','POINT','포인트 잔액이 부족하면 알림이 오나요?','알림 메시지는 따로 제공되지 않지만,\n\n단체 게임의 경우 최소 베팅 금액보다 포인트가 부족하면 게임방에 입장할 수 없습니다.\n개인 게임의 경우 잔액이 0원이면 베팅 및 게임 진행이 불가합니다.'),('e283b45880fb4d44baa2e1721aa1affe','ETC','SYSTEM','자동 로그아웃 기능이 있나요?','현재는 자동 로그아웃 기능은 적용되어 있지 않습니다.\n보안을 위해 장시간 자리를 비우실 경우 수동 로그아웃을 권장드립니다.'),('e51fa7de8667498698e61e8d4e45a399','POINT','POINT','포인트 충전이 실패하면 어떻게 해야 하나요?','포인트 충전 관련 문제가 발생한 경우,\n**[고객지원] > [1:1 문의]**를 통해 문의해 주시면 빠르게 안내 도와드리겠습니다.'),('ea0d8c1e78aa4250a9d168a31da7a153','GAME','RULE','게임별 룰은 업데이트되기도 하나요?','네, 게임 룰은 운영 정책에 따라 주기적으로 업데이트될 수 있습니다.\n변경 사항은 [고객지원] > [공지사항]을 통해 안내되오니, 정기적으로 확인해 주세요.'),('f8375b07b780414180e2caec2d137e22','GAME','RULE','배팅 시간 초과 시 자동으로 패배 처리되나요?','현재 게임에는 별도의 배팅 시간 제한은 없습니다.\n또한, 게임 중 ‘나가기’를 하지 않는 이상 자동 패배 처리되지는 않으니 안심하고 플레이하실 수 있습니다.'),('fc1e9a9e5f7a4d1eafff123baea01980','ETC','ACCOUNT','비밀번호 변경 어떻게 해?','마이페이지 > 나의 정보> 수정하기 메뉴에서 가능합니다.');
/*!40000 ALTER TABLE `chatbot_qa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_verification`
--

DROP TABLE IF EXISTS `email_verification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_verification` (
  `email` varchar(100) NOT NULL,
  `verification_code` varchar(6) DEFAULT NULL,
  `expired_at` datetime DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `game`
--

DROP TABLE IF EXISTS `game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game` (
  `uid` char(32) NOT NULL COMMENT '게임 고유 식별자',
  `name` varchar(255) NOT NULL COMMENT '게임 이름',
  `type` varchar(50) NOT NULL COMMENT '게임 유형: SINGLE(개인), MULTI(단체)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `game_img` varchar(255) DEFAULT '' COMMENT '게임 이미지 경로',
  `status` varchar(50) DEFAULT 'ACTIVE' COMMENT '사용 가능 여부 (ACTIVE, INACTIVE)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game`
--

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;
INSERT INTO `game` VALUES ('0a644307148b4446857a624dc2a6e3b2','Turtle Run','MULTI','?거북이:우승이 예상되는 거북이를 선택하고 원하는 금액을 배팅합니다.\n<br>?빛나는것:레이스를 진행하여 우승한 거북이를 선택한 사람이 배당 로직을 통하여 포인트를 얻게됩니다.\n<br>☠️해적_표시:게임 종료 전 퇴장 혹은 연결이 끊길 시에 패배 처리하고 배팅한 포인트를 잃게 됩니다.','fdba50b3-3015-4cc0-9f0f-fbd45f32eb04.png','ACTIVE','2025-06-24 15:59:11'),('6af4652b53f94d6194c7d7aef2d6ac43','TreasureHunt','SINGLE',' ?️사용자가 계속해서 타일을 클릭하며 숨겨진 보석을 찾는 게임입니다.\n<br> ? 난이도가 높을수록 승리 시 획득 포인트가 커집니다.','d504208d-7544-4873-8189-c847e199f96a.png','ACTIVE','2025-07-01 14:20:44'),('f47ac10b58cc4372a5670e02b2c3d479','CoinToss','SINGLE','?️사용자는 난이도를 선택하고 포인트를 배팅해 동전을 던지는 게임입니다.\n<br>?난이도가 높을수록 승리 시 획득 포인트가 커집니다.','72b5f019-7a47-4c0e-b3b8-286b464cd1ab.png','ACTIVE','2025-06-24 16:14:15');
/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_history`
--

DROP TABLE IF EXISTS `game_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_history` (
  `uid` char(32) NOT NULL COMMENT '게임 참여 이력 고유 식별자',
  `user_uid` char(32) NOT NULL COMMENT '참여한 사용자',
  `game_uid` char(32) NOT NULL COMMENT '어떤 게임인지 확인',
  `betting_amount` int NOT NULL COMMENT '배팅 포인트(얼마를 걸었는지)',
  `game_result` varchar(20) DEFAULT NULL COMMENT 'WIN / LOSE',
  `point_value` int DEFAULT NULL COMMENT '배당 포인트(게임 결과에 따른 배당 포인트[-10, +10])',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '게임 결과 기록 시간',
  PRIMARY KEY (`uid`),
  KEY `user_uid` (`user_uid`),
  KEY `game_uid` (`game_uid`),
  CONSTRAINT `game_history_ibfk_1` FOREIGN KEY (`user_uid`) REFERENCES `user` (`uid`),
  CONSTRAINT `game_history_ibfk_2` FOREIGN KEY (`game_uid`) REFERENCES `game` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `game_level`
--

DROP TABLE IF EXISTS `game_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_level` (
  `uid` char(32) NOT NULL COMMENT '게임 고유 식별자',
  `game_uid` char(32) NOT NULL COMMENT '어떤 게임인지 확인',
  `level` varchar(50) NOT NULL COMMENT '난이도',
  `probability` double NOT NULL COMMENT '확률',
  `reward` double NOT NULL COMMENT '배당',
  PRIMARY KEY (`uid`),
  KEY `game_uid` (`game_uid`),
  CONSTRAINT `game_level_ibfk_1` FOREIGN KEY (`game_uid`) REFERENCES `game` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_level`
--

LOCK TABLES `game_level` WRITE;
/*!40000 ALTER TABLE `game_level` DISABLE KEYS */;
INSERT INTO `game_level` VALUES ('128c526008fc4156bbf00b56b8f9add6','0a644307148b4446857a624dc2a6e3b2','HARD',12.5,400),('37ebb4206285479bbb05d3539e5a1d9f','6af4652b53f94d6194c7d7aef2d6ac43','EASY',80,105),('4159e91e7a0a4817a269ef5cf0e68498','f47ac10b58cc4372a5670e02b2c3d479','HARD',30,330),('503fbb07d56e4b69a1eb15ccb6bb00e8','f47ac10b58cc4372a5670e02b2c3d479','NORMAL',50,200),('53416e54f2234ea3be000c90de5b20e9','6af4652b53f94d6194c7d7aef2d6ac43','HARD',40,280),('b84e84d5c97449939436aae0ca4fe57f','0a644307148b4446857a624dc2a6e3b2','NORMAL',16.6,250),('d6d26ff7009448a8b89aa2286ac38c3d','f47ac10b58cc4372a5670e02b2c3d479','EASY',70,120),('e1c8557bd5474aab8d4d6eca4ecbe835','0a644307148b4446857a624dc2a6e3b2','EASY',25,120),('fbd7c0c88efc470482c32fecf323008d','6af4652b53f94d6194c7d7aef2d6ac43','NORMAL',60,130);
/*!40000 ALTER TABLE `game_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_room`
--

DROP TABLE IF EXISTS `game_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_room` (
  `uid` char(32) NOT NULL COMMENT '게임방 고유 식별자',
  `game_level_uid` char(32) NOT NULL COMMENT '어떤 게임-난이도인지 확인',
  `host_uid` char(32) NOT NULL COMMENT '방 생성자 (주최자)',
  `title` varchar(255) DEFAULT NULL COMMENT '방 제목 또는 설명',
  `min_bet` int DEFAULT '0' COMMENT '최소 배팅 포인트',
  `status` varchar(50) DEFAULT 'WAITING' COMMENT 'WAITING / PLAYING / CLOSED',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '방 생성 시간',
  `started_at` datetime DEFAULT NULL COMMENT '게임 시작 시간',
  PRIMARY KEY (`uid`),
  KEY `host_uid` (`host_uid`),
  KEY `game_level_uid` (`game_level_uid`),
  CONSTRAINT `game_room_ibfk_1` FOREIGN KEY (`host_uid`) REFERENCES `user` (`uid`),
  CONSTRAINT `game_room_ibfk_2` FOREIGN KEY (`game_level_uid`) REFERENCES `game_level` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_room`
--

LOCK TABLES `game_room` WRITE;
/*!40000 ALTER TABLE `game_room` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `uid` varchar(36) NOT NULL COMMENT 'payment_uid, UUID 기반 PK',
  `pay_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` int NOT NULL COMMENT '결제 금액',
  `order_uid` varchar(50) NOT NULL COMMENT '가맹점 주문 UID',
  `order_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_uid` varchar(36) NOT NULL COMMENT '결제 사용자 UID',
  `payment_key` varchar(100) DEFAULT NULL COMMENT '토스페이먼츠 payment_key',
  `status` enum('PENDING','PAID','FAILED','CANCELED') DEFAULT 'PENDING' COMMENT '결제 상태',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '결제 생성 시각',
  `approve_at` datetime DEFAULT NULL COMMENT '결제 승인 시각',
  `failure_reason` varchar(500) DEFAULT NULL COMMENT '결제 실패 사유',
  `receipt_url` varchar(500) DEFAULT NULL COMMENT '토스페이먼츠 영수증 URL',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `order_uid` (`order_uid`),
  UNIQUE KEY `payment_key` (`payment_key`),
  KEY `fk_payment_user_uid` (`user_uid`),
  CONSTRAINT `fk_payment_user_uid` FOREIGN KEY (`user_uid`) REFERENCES `user` (`uid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `point_history`
--

DROP TABLE IF EXISTS `point_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `point_history` (
  `uid` char(32) NOT NULL COMMENT '고유 식별자',
  `user_uid` char(32) NOT NULL COMMENT '어떤 사용자의 포인트 기록인지 확인',
  `type` varchar(50) NOT NULL COMMENT '구매, 베팅, 환불 등',
  `amount` int NOT NULL COMMENT '변화된 포인트 양',
  `balance_after` int NOT NULL COMMENT '거래 후 사용자의 잔액',
  `gh_uid` char(32) DEFAULT NULL COMMENT '포인트 변화에 대한 게임 Data ID',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '기록 생성 시간',
  PRIMARY KEY (`uid`),
  KEY `gh_uid` (`gh_uid`),
  KEY `user_uid` (`user_uid`),
  CONSTRAINT `point_history_ibfk_1` FOREIGN KEY (`gh_uid`) REFERENCES `game_history` (`uid`),
  CONSTRAINT `point_history_ibfk_2` FOREIGN KEY (`user_uid`) REFERENCES `user` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `uid` char(32) NOT NULL COMMENT '고유 식별자',
  `user_name` varchar(50) NOT NULL COMMENT '사용자 이름',
  `password` varchar(100) NOT NULL COMMENT '비밀번호',
  `nickname` varchar(100) NOT NULL COMMENT '서비스 내 닉네임',
  `email` varchar(100) NOT NULL COMMENT '로그인 ID',
  `birth_date` date DEFAULT NULL COMMENT '생년월일',
  `phone_number` varchar(30) DEFAULT NULL COMMENT '전화번호',
  `agree_privacy` tinyint(1) DEFAULT '0' COMMENT '개인정보 동의 여부',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
  `updated_at` datetime DEFAULT NULL COMMENT '수정일',
  `last_login_at` datetime DEFAULT NULL COMMENT '마지막 로그인 시간',
  `role` varchar(50) DEFAULT 'USER' COMMENT '권한',
  `point_balance` int DEFAULT '0' COMMENT '보유 포인트',
  `profile_img` varchar(255) DEFAULT '' COMMENT '프로필 이미지 경로',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-30  9:06:19
