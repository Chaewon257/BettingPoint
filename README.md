# 🎯 Betting Point - 금융 베팅 게임 플랫폼

Betting Point는 사용자들이 포인트를 사용해 재미있게 배팅 게임을 즐길 수 있도록 기획된 **금융형 배팅 플랫폼**입니다.  
**단체 및 개인 게임**, **배당금 시스템**, **고객 지원 기능**을 통해 사용자 몰입도와 소셜 참여를 높이고자 합니다.

<br/>

## 🛠️ 기술 스택

### ✅ 개발 환경
- IDE: Eclipse, STS3, MySQL Workbench
- DB: MySQL
- Server: Apache Tomcat
- 형상 관리: Git, GitHub
- 협업 도구: Notion, Figma, Slack

### ✅ 사용 언어 및 라이브러리
- Language: Java, MySQL  
- Front-end: HTML, CSS, JavaScript  
- Back-end: Spring Framework  
- Library: TailwindCSS, AJAX, WebSocket, AWS S3, JavaMailSender, Toss Payments  

<br/>

## 📌 주요 기능

- ✅ 포인트 충전 및 차감 기반의 **베팅 게임 기능**
- ✅ 실시간 소켓 기반의 **단체 게임 지원**
- ✅ **배당금 정산 및 자동 분배 시스템**
- ✅ 관리자/유저 권한 구분 및 **마이페이지 관리 기능**
- ✅ **공지사항**, **문의/채팅**, **게시판** 등 커뮤니티 요소
- ✅ **Toss Payments**를 통한 결제 기능 연동
- ✅ **AWS S3 기반** 이미지 업로드 및 관리
- ✅ **JavaMailSender**를 통한 인증 및 알림 이메일 발송

<br/>

## 🧩 UI/UX 흐름도

> 전체 흐름 구조도 (클릭 시 확대)

![UI/UX 설계](./images/81902cf1-a55a-46e0-ac81-f1794833fbb4.png)

<br/>

## 📁 프로젝트 구조

```bash
📦 BettingPoint
 ┣ 📂src
 ┃ ┣ 📂main
 ┃ ┃ ┣ 📂java/com/bettopia/game
 ┃ ┃ ┃ ┣ 📂Exception
 ┃ ┃ ┃ ┣ 📂config
 ┃ ┃ ┃ ┣ 📂controller
 ┃ ┃ ┃ ┣ 📂filter
 ┃ ┃ ┃ ┣ 📂model
 ┃ ┃ ┃ ┣ 📂socket
 ┃ ┃ ┃ ┗ 📂util
 ┃ ┃ ┣ 📂resources
 ┃ ┃ ┗ 📂webapp
 ┃ ┃ ┃ ┣ 📂WEB-INF
 ┃ ┃ ┃ ┃ ┣ 📂spring
 ┃ ┃ ┃ ┃ ┣ 📂tags
 ┃ ┃ ┃ ┃ ┣ 📂views
 ┃ ┃ ┃ ┃ ┗ web.xml
 ┃ ┃ ┃ ┗ 📂resources
 ┃ ┃ ┃ ┃ ┣ 📂css
 ┃ ┃ ┃ ┃ ┣ 📂images
 ┃ ┃ ┃ ┃ ┗ 📂js
 ┣ 📂test
 ┃ ┗ 📂resources
````

<br/>

## 🚀 실행 방법

```bash
git clone https://github.com/SinhanDS-Project/BettingPoint.git
cd BettingPoint
# Eclipse 또는 STS를 통해 프로젝트 Import 후, 서버 실행 (Tomcat)
```

<br/>

## 📸 기타 자료

| 사용 기술 소개                                                    | UI 흐름도                                                       |
| ----------------------------------------------------------- | ------------------------------------------------------------ |
| ![기술 스택](./images/677bb5f5-eac4-485b-a561-5782323c8340.png) | ![UI 흐름도](./images/37a8885a-7a28-4911-9ad7-30727fad1256.png) |

<br/>

## 📄 라이선스

해당 프로젝트는 비상업적 목적의 교육 프로젝트로, 상업적 이용을 금합니다.
