import { Controller } from "@hotwired/stimulus"
import Swiper from "swiper"
import "swiper/css"

export default class extends Controller {
  connect() {
    this.swiper = new Swiper(this.element, {
      loop: true,
      pagination: {
        el: this.element.querySelector(".swiper-pagination"),
        clickable: true,
      },
      navigation: {
        nextEl: this.element.querySelector(".swiper-button-next"),
        prevEl: this.element.querySelector(".swiper-button-prev"),
      },
    })
  }
}
