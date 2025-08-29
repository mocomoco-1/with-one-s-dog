class ReplaceDiagnosisSeeds < ActiveRecord::Migration[7.2]
  def up
    # 依存関係順に削除（ChoicesDiagnosis → Choice → Diagnosis → Question）
    ChoicesDiagnosis.delete_all
    Choice.delete_all
    Diagnosis.delete_all
    Question.delete_all

    # 質問を作成
    q1 = Question.create!(text: "わんこ、今どこで何してる？")
    q2 = Question.create!(text: "ごはんを出すと、どんな顔をする？")
    q3 = Question.create!(text: "お散歩の気配を感じたときは？")
    q4 = Question.create!(text: "飼い主と目が合った時のリアクションは？")
    q5 = Question.create!(text: "しっぽ、今どんな感じ？")

    # 選択肢を作成（犬目線を意識）
    c1 = Choice.create!(text: "ひざの上でぬくぬく…「ここがいちばん安心する」", question: q1)
    c2 = Choice.create!(text: "部屋のすみっこでじっと考え事「ふむふむ…」", question: q1)
    c3 = Choice.create!(text: "窓の外をじーっと見つめる「今日も冒険の予感」", question: q1)
    c4 = Choice.create!(text: "おうちの中を駆けまわりながら「わーーーーん！！」", question: q1)

    c5 = Choice.create!(text: "くるくる回って興奮Max!", question: q2)
    c6 = Choice.create!(text: "そっと近づいてお座り。「おりこうさんだからください！」", question: q2)
    c7 = Choice.create!(text: "じーっと見つめて固まる「これは、、、32グラムだろうか。」", question: q2)
    c8 = Choice.create!(text: "お気に入りの場所に持って行って「あとでゆっくり探検ごっこするんだ」", question: q2)

    c9  = Choice.create!(text: "すぐにリードを取りに行って「ねえ、今日はどこ行く？」", question: q3)
    c10 = Choice.create!(text: "ドアの前でおすわり「一緒にお出かけうれしいな」", question: q3)
    c11 = Choice.create!(text: "「今日はもう終わったよ！（頭の中で）」", question: q3)
    c12 = Choice.create!(text: "「もう今日は探検よりお昼寝優先かな」", question: q3)

    c13 = Choice.create!(text: "じーっと見つめて「どうしたらおやつがもらえるだろうか」", question: q4)
    c14 = Choice.create!(text: "ごろんと「動く気力はありません」", question: q4)
    c15 = Choice.create!(text: "必殺へそ天!「なでて～」", question: q4)
    c16 = Choice.create!(text: "キラキラ目で「一緒に冒険に行こう！」", question: q4)

    c17 = Choice.create!(text: "ブンブン全開！「いま最高にしあわせだよ！」", question: q5)
    c18 = Choice.create!(text: "ゆっくりふりふり「かいぬし見ているだけで幸せ」", question: q5)
    c19 = Choice.create!(text: "微動だにせず「しっぽも寝てるの」", question: q5)
    c20 = Choice.create!(text: "ピンと立って「新しい発見の予感！」", question: q5)

    # 診断結果を作成
    d1 = Diagnosis.create!(title: "ずっと見てたい…天使のまどろみモード💤", explanation: "「ねむねむしあわせ」
      まぶたがとろ〜ん、体もまるっとくるんと丸まって。
      夢の世界とあなたの匂いの間をふわふわ行き来しながら、しあわせを満喫中。
      たまに小さな寝言や足のピクピクで、“どんな夢見てるんだろう”って気になるくらい愛おしい。", dog_message: "「…Zzz（なでるのは歓迎だけど、起こさないでね）」")

    d2 = Diagnosis.create!(title: "ちょっと不思議でかわいすぎる。考えごとモード💭", explanation: "「今日のごはんは昨日より１グラム多かったな。これは原因を考えねば。」
      じーっと窓の外や空を眺めて、頭の中でいろんなシミュレーション中。
      おやつの順番、お散歩のルート、飼い主の帰宅時間まで…すべては真剣なテーマ。
      声をかけても聞こえてないくらい没頭してる姿に、思わずクスッとしちゃう。", dog_message: "「いま大事なこと考えてるから、あとで遊ぼ？」")

    d3 = Diagnosis.create!(title: "吸引力がすごい。甘えんぼモード💓", explanation: "「ちょっとそこに座ってて？…うん、ずっとね。」
      とにかくあなたのそばにいたい！移動すればすぐ追いかけて、
      ひざのすき間にぴったりフィット。
      しっぽはぽふぽふ、目はうるうる…
      全身からあふれる“そばにいたい”ビームが止まらない。", dog_message: "「ひざ、空いてる？（空いてなくても乗るけど）」")

    d4 = Diagnosis.create!(title: "なんか今日めちゃ元気！ハイテンションモード🐕", explanation: "「わーーー！楽しい！！ねえ見て見て！！」
      ごはんでジャンプ！お散歩でダッシュ！おやつでしっぽ竜巻！
      全身で「うれしい」を表現して、家中をパレードみたいに駆けまわる。
      ちょっとぶつかっちゃうくらいのパワフルさも、笑って許したくなる愛嬌のひとつ。", dog_message: "「おすわり？もちろんできるよ！（3秒限定）」")

    d5 = Diagnosis.create!(title: "未知との出会いにワクワク！冒険モード🌍", explanation: "「この先になにがあるのかな？クンクン…新しい発見のにおい！」
      今日は小さな探検家。ソファの下も庭の隅も、ぜんぶ冒険のフィールド。
      知らない音、知らないにおい、ぜんぶ発見のチャンス。
      気づけばあなたも一緒に冒険に巻き込まれて、楽しい時間が始まります。", dog_message: "「次はどっちに行く？ 一緒に探検しよう！」")

    # 選択肢と診断結果を紐付け
    ChoicesDiagnosis.create!(choice: c1, diagnosis: d1)
    ChoicesDiagnosis.create!(choice: c2, diagnosis: d2)
    ChoicesDiagnosis.create!(choice: c3, diagnosis: d5)
    ChoicesDiagnosis.create!(choice: c4, diagnosis: d4)

    ChoicesDiagnosis.create!(choice: c5, diagnosis: d4)
    ChoicesDiagnosis.create!(choice: c6, diagnosis: d3)
    ChoicesDiagnosis.create!(choice: c7, diagnosis: d2)
    ChoicesDiagnosis.create!(choice: c8, diagnosis: d5)

    ChoicesDiagnosis.create!(choice: c9, diagnosis: d4)
    ChoicesDiagnosis.create!(choice: c10, diagnosis: d3)
    ChoicesDiagnosis.create!(choice: c11, diagnosis: d2)
    ChoicesDiagnosis.create!(choice: c12, diagnosis: d1)

    ChoicesDiagnosis.create!(choice: c13, diagnosis: d2)
    ChoicesDiagnosis.create!(choice: c14, diagnosis: d1)
    ChoicesDiagnosis.create!(choice: c15, diagnosis: d3)
    ChoicesDiagnosis.create!(choice: c16, diagnosis: d5)

    ChoicesDiagnosis.create!(choice: c17, diagnosis: d4)
    ChoicesDiagnosis.create!(choice: c18, diagnosis: d3)
    ChoicesDiagnosis.create!(choice: c19, diagnosis: d1)
    ChoicesDiagnosis.create!(choice: c20, diagnosis: d5)
  end

  def down
    ChoicesDiagnosis.delete_all
    Choice.delete_all
    Diagnosis.delete_all
    Question.delete_all
  end
end

