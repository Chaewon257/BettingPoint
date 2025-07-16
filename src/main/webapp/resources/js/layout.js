// 스크롤 시 네비게이션 바 고정 함수
window.addEventListener("scroll", () => {
  const nav = document.querySelector(".nav-bar");
  const container = document.querySelector(".main-container");
  const trigger = document.querySelector(".site-title-box").offsetHeight;
  
  const fixedClasses = ["fixed", "top-0", "left-0", "right-0", "shadow-md"];

  if (window.scrollY >= trigger) {
    nav.classList.add(...fixedClasses);
    container.classList.add("pt-[5.938rem]");
  } else {
    nav.classList.remove(...fixedClasses);
    container.classList.remove("pt-[5.938rem]");
  }
});