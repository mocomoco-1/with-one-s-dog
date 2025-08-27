import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="diagnosis"
export default class extends Controller {
  static targets = [
    "question",
    "progressBar",
    "progressText",
    "errorMessage",
    "errorText",
    "nextBtn",
    "prevBtn",
  ];
  // ターゲットは、HTML内でdata-target属性を使って指定する
  static values = {
    totalQuestions: Number,
    currentQuestion: Number,
    // 質問の総数(数値として扱う),現在の質問のインデックス(数値)
    // HTML内でdata-value属性を使って設定できる
  };
  connect() {
    // controllerが接続されたときに実行されるメソッド。
    this.currentQuestionValue = 0;
    // 現在の質問のインデックスを保持するプロパティ。最初の問題
    this.answers = {};
    // 選んだ解答を保存するためのオブジェクト
    this.updateDisplay();

    console.log("診断コントローラーが接続されました🐶");
    console.log("総質問数:", this.totalQuestionsValue);
  }

  nextQuestion() {
    if (this.validateCurrentQuestion()) {
      this.saveCurrentAnswer();

      if (this.currentQuestionValue === this.totalQuestionsValue - 1) {
        this.submitAnswers();
      } else {
        this.currentQuestionValue++;
        this.updateDisplay();
      }
    }
    // 次の質問に進むメソッド。現在の質問に対する回答が有効かどうか確認→trueのとき次へそれ以外は何も進まない
    // →現在の解答を保存(バックエンドへ)→現在の質問が最後の質問かどうか判定→最後の質問ならすべての解答を送信する処理
    // →でなければインデックスを足して次の質問へ。そして表示も更新
  }
  prevQuestion() {
    if (this.currentQuestionValue > 0) {
      this.saveCurrentAnswer();
      this.currentQuestionValue--;
      this.updateDisplay();
      // ()があることでメソッドを実行している。ないとただの参照
    }
  }
  validateCurrentQuestion() {
    const currentQuestionElement =
      this.questionTargets[this.currentQuestionValue];
    const selectedChoice = currentQuestionElement.querySelector(
      'input[type="radio"]:checked'
    );
    // currentQuestionElementから☑されたラジオボタンを取得。
    if (!selectedChoice) {
      this.showError("選択肢を選んでください🐕");
      return false;
    }
    this.hideError();
    // 選択肢が選ばれている場合はエラーを隠す処理
    return true;
  }
  saveCurrentAnswer() {
    const currentQuestionElement =
      this.questionTargets[this.currentQuestionValue];
    const selectedChoice = currentQuestionElement.querySelector(
      'input[type="radio"]:checked'
    );

    if (selectedChoice) {
      const questionId = currentQuestionElement.dataset.questionId;
      this.answers[questionId] = selectedChoice.value;
      // currentQuestionElementから質問IDを取得してthis.answersオブジェクトにキーとして値を保存。
    }
  }

  updateDisplay() {
    this.questionTargets.forEach((question, index) => {
      if (index === this.currentQuestionValue) {
        question.classList.remove("hidden");
      } else {
        question.classList.add("hidden");
      }
    });
    // questionTargetsに含まれるすべての質問をループして、各質問要素とそのインデックスを取得している
    // indexが質問のindexと等しいとき、hiddenを削除して表示

    const progress =
      ((this.currentQuestionValue + 1) / this.totalQuestionsValue) * 100;
    this.progressBarTarget.style.width = `${progress}%`;
    // progressBarの幅更新
    this.progressTextTarget.textContent = `質問 ${
      this.currentQuestionValue + 1
    } / ${this.totalQuestionsValue}`;
    // progressText更新
    this.updateButtons();
  }

  updateButtons() {
    if (this.currentQuestionValue > 0) {
      this.prevBtnTarget.classList.remove("hidden");
    } else {
      this.prevBtnTarget.classList.add("hidden");
    }
    // prevボタンを最初の問題以外は表示させる

    if (this.currentQuestionValue === this.totalQuestionsValue - 1) {
      this.nextBtnTarget.textContent = "診断結果を見る🐶";
    } else {
      this.nextBtnTarget.textContent = "次の問題へ→";
    }
  }

  showError(message) {
    this.errorMessageTarget.textContent = message;
    this.errorMessageTarget.classList.remove("hidden");
  }

  hideError() {
    this.errorMessageTarget.classList.add("hidden");
  }

  submitAnswers() {
    const form = document.getElementById("diagnosis-form");
    // フォームのIDがdiagnosis-formの要素を取得している
    const answersInput = document.getElementById("answers-data");
    answersInput.value = JSON.stringify(this.answers);
    // this.answersの内容をJSON形式の文字列に変換してanswerInputのvalueに設定。これにより解答がフォーム送信時に適切に送られるようになる
    form.submit();
  }
}
