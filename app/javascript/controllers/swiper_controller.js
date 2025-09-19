import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper"
import { Navigation, Pagination } from 'swiper/modules'

export default class extends Controller {
  connect() {
    console.log("🌷swiper")
    this.swiper = new Swiper(this.element, {
      modules: [Navigation, Pagination],
      loop: true,
      slidesPerView: 1,
      spaceBetween: 10,
      pagination: {
        el: this.element.querySelector(".swiper-pagination"),
        clickable: true,
      },
      watchOverflow: true,
      navigation: {
        nextEl: this.element.querySelector(".custom-next-btn"),
        prevEl: this.element.querySelector(".custom-prev-btn"),
      },
    })
  }
}
