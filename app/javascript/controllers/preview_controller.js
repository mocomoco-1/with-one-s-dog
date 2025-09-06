import { Controller } from "@hotwired/stimulus";

// data-controller="preview" が付いた要素に紐づく
export default class extends Controller {
  // HTML 側で data-preview-target="input" / "image" と書いた要素を
  static targets = [ "input", "images" ]
  static values = {
    maxWidth: { type: Number, default: 1920 },
    maxHeight: { type: Number, default: 1080 },
    quality: { type: Number, default: 0.8 },
    enableResize: { type: Boolean, default: true }
  }
  initialize() {
    this.resizedFiles = []
  }
  preview(){
     // <input type="file"> に選ばれた最初のファイル（1枚目）を取り出す
    const files = this.inputTarget.files
    if (!files || files.length === 0) return
    // プレビューをクリア
    while (this.imagesTarget.firstChild) {
      this.imagesTarget.removeChild(this.imagesTarget.firstChild)
    }
    this.resizedFiles = []
    Array.from(files).forEach(file => {
      if (!file.type.startsWith("image/")){
        alert("画像ファイルを選択してください")
        return
      }
      // リサイズが有効な場合はリサイズ処理を実行、無効な場合は従来通りの処理
      if (this.enableResizeValue){
        this.previewWithResize(file)
      }else{
        this.previewOriginal(file)
      }
    })
  }
  // リサイズなしプレビュー
  previewOriginal(file){
    // ブラウザに用意されている読み込み用オブジェクト
    const reader = new FileReader()
    // 読み込み完了時に呼ばれるコールバック
    reader.onload = (e) =>{
      // e.target.result には「画像の中身を文字列化したデータURL」が入る
      // これを <img> の src に入れると、即座に画面に表示できる
      this.appendImage(e.target.result)
      const originalFile = new File([file], file.name, { type: file.type, lastModified: Date.now() })
      this.resizedFiles.push(originalFile)
    }
    reader.readAsDataURL(file)
  }

  // リサイズ付きプレビュー
  previewWithResize(file){
    const reader = new FileReader()
    reader.onload = (e) => {
      const img = new Image()
      img.onload = () => {
        try{
          this.resizeAndPreview(img, file)
        }catch (error){
          console.error("リサイズでエラーが発生しました", error)
          this.appendImage(e.target.result)
          this.addResizedFile(file)
        }
      }
      img.onerror = () => {
        console.error('画像の読み込みに失敗しました')
      }
      img.src = e.target.result
    }
    reader.readAsDataURL(file)
  }
  // プレビュー用 <img> を作って追加
  appendImage(src) {
    const imgElement = document.createElement("img")
    imgElement.src = src
    imgElement.classList.add("w-32", "h-32", "object-cover", "m-2")
    if (this.imagesTarget.classList.contains("icon-preview")) {
    imgElement.classList.add("w-36", "h-36", "rounded-full")  // 丸く
    } else {
    imgElement.classList.add("w-32", "h-32", "rounded-lg")    // 四角く
    }
    this.imagesTarget.appendChild(imgElement)
  }
  // リサイズ処理とプレビュー表示
  resizeAndPreview(img, originalFile) {
    // HTML5のCanvasエレメントを作成
    const canvas = document.createElement("canvas")
    // 2Dコンテキストを取得（描画操作用）
    const ctx = canvas.getContext("2d")
    // 元画像のサイズを取得
    const originalWidth = img.width
    const originalHeight = img.height

    const ratio = Math.min(
      this.maxWidthValue / originalWidth,
      this.maxHeightValue / originalHeight
    )
    // 新しいサイズを計算
    const newWidth = Math.round(originalWidth * ratio)
    const newHeight = Math.round(originalHeight * ratio)
    canvas.width = newWidth
    canvas.height = newHeight
    ctx.drawImage(img, 0, 0, newWidth, newHeight)
    canvas.toBlob((blob) => {
      // BlobからURLを作成してプレビュー表示
      const resizeUrl = URL.createObjectURL(blob)
      this.appendImage(resizeUrl)
      const resizedFile = new File([blob], originalFile.name, {
        type: 'image/jpeg',
        lastModified: Date.now()
      })
      this.addResizedFile(resizedFile)
    },
    "image/jpeg", this.qualityValue
    )
  }
  addResizedFile(file) {
    this.resizedFiles.push(file)
    if (this.resizedFiles.length === this.inputTarget.files.length) {
      const dataTransfer = new DataTransfer()
      this.resizedFiles.forEach(file => dataTransfer.items.add(file))
      this.inputTarget.files = dataTransfer.files
    }
  }
}