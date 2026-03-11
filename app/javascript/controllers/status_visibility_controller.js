// 新規投稿画面の視聴状態によって項目を非表示・表示にする
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["status", "form"]

    connect() {
        this.toggle() //ページを開いた瞬間の状態を確認
    }

    toggle() {
        //セレクトボックスで選ばれている値を取得
        const statusValue = this.statusTarget.value

        // 「みたい」なら隠す、それ以外は表示
        if (statusValue == "want_to_watch") {
            this.formTarget.classList.add("hidden") //非表示にする
        } else {
            this.formTarget.classList.remove("hidden") //表示する
        }
    }
}