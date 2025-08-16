import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="menu-toggle"
export default class extends Controller {
  static targets = ["sidebar", "overlay"];
  // targetsはhtmlを取得するための名前を定義している
  connect() {
    console.log("MenuToggle controller connected");
  }
  // connectはコントローラがhtml要素に接続されたときに実行される(ページ読み込み時に自動で)
  toggle() {
    console.log("Menu toggle clicked");
    this.sidebarTarget.classList.toggle("-translate-x-full");
    this.overlayTarget.classList.toggle("hidden");
  }
  // toggleはハンバーガーをクリックしたときに実行。translate…は左に100%移動。
  close() {
    console.log("Menu closing");
    this.sidebarTarget.classList.add("-translate-x-full");
    this.overlayTarget.classList.add("hidden");
  }
}
