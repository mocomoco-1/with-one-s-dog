import { Controller } from "@hotwired/stimulus";

// data-controller="preview" が付いた要素に紐づく
export default class extends Controller {
  // HTML 側で data-preview-target="input" / "image" と書いた要素を
  // this.inputTarget / this.imageTarget として扱えるようにする宣言
  static targets = [ "input", "image" ]
  preview(){
     // <input type="file"> に選ばれた最初のファイル（1枚目）を取り出す
    const file = this.inputTarget.files[0]
    if (!file) return
    // ブラウザに用意されている読み込み用オブジェクト
    const reader = new FileReader()
    // 読み込み完了時に呼ばれるコールバック
    reader.onload = (e) =>{
      // e.target.result には「画像の中身を文字列化したデータURL」が入る
      // これを <img> の src に入れると、即座に画面に表示できる
      this.imageTarget.src = e.target.result
    }
    reader.readAsDataURL(file)
  }
}