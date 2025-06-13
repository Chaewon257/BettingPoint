// 스크롤 시 네비게이션 바 고정 함수
window.addEventListener("scroll", () => {
  const nav = document.querySelector(".nav-bar");
  const trigger = document.querySelector(".site-title-box").offsetHeight;

  if (window.scrollY >= trigger) {
    nav.classList.add("fixed");
  } else {
    nav.classList.remove("fixed");
  }
});