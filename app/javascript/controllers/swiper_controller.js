import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper"
import { Navigation, Pagination } from 'swiper/modules'
console.log("=== SwiperController loaded ===")
export default class extends Controller {
  connect() {
    console.log("Swiper connect:", this.element)
    this.swiper = new Swiper(this.element, {
      modules: [Navigation, Pagination],
      loop: true,
      slidesPerView: 1,   // 1枚だけ表示する
      spaceBetween: 10,
      pagination: {
        el: this.element.querySelector(".swiper-pagination"),
        clickable: true,
      },
      navigation: {
        nextEl: this.element.querySelector(".custom-next-btn"),
        prevEl: this.element.querySelector(".custom-prev-btn"),
      },
    })
  }
}
