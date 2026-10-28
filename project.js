const accordions = document.querySelectorAll(".accordion-btn");

accordions.forEach((btn) => {
  btn.addEventListener("click", () => {
    const content = btn.nextElementSibling;
    const isOpen = content.classList.contains("open");

    document.querySelectorAll(".accordion-content").forEach((item) => {
      item.classList.remove("open");
      item.style.maxHeight = null;
      item.previousElementSibling.classList.remove("active");
    });

    if (!isOpen) {
      btn.classList.add("active");
      content.classList.add("open");
      content.style.maxHeight = content.scrollHeight + "px";
    }
  });
});

const slides = document.querySelectorAll(".visual-slide");
const next = document.querySelector(".nav.next");
const prev = document.querySelector(".nav.prev");

if (slides.length && next && prev) {
  let index = 0;

  function showSlide(i) {
    slides.forEach(slide => slide.classList.remove("active"));
    slides[i].classList.add("active");

    prev.classList.toggle("disabled", i === 0);
    next.classList.toggle("disabled", i === slides.length - 1);
  }

  next.addEventListener("click", () => {
    if (index < slides.length - 1) {
      index++;
      showSlide(index);
    }
  });

  prev.addEventListener("click", () => {
    if (index > 0) {
      index--;
      showSlide(index);
    }
  });

  showSlide(index);
}