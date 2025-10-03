    # 質問
    q1 = Question.find_or_create_by!(text: "わんこ、今どこで何してる？")
    q2 = Question.find_or_create_by!(text: "ごはんを出すと、どんな顔をする？")
    q3 = Question.find_or_create_by!(text: "お散歩の気配を感じたときは？")
    q4 = Question.find_or_create_by!(text: "飼い主と目が合った時のリアクションは？")
    q5 = Question.find_or_create_by!(text: "しっぽ、今どんな感じ？")

    # 選択肢
    c1 = Choice.find_or_create_by!(text: "ひざの上でぬくぬく…「ここがいちばん安心する」", question: q1)
    c2 = Choice.find_or_create_by!(text: "部屋のすみっこでじっと考え事「ふむふむ…」", question: q1)
    c3 = Choice.find_or_create_by!(text: "窓の外をじーっと見つめる「今日も冒険の予感」", question: q1)
    c4 = Choice.find_or_create_by!(text: "おうちの中を駆けまわりながら「わーーーーん！！」", question: q1)

    c5 = Choice.find_or_create_by!(text: "くるくる回って興奮Max!", question: q2)
    c6 = Choice.find_or_create_by!(text: "そっと近づいてお座り。「おりこうさんだからください！」", question: q2)
    c7 = Choice.find_or_create_by!(text: "じーっと見つめて固まる「これは、、、32グラムだろうか。」", question: q2)
    c8 = Choice.find_or_create_by!(text: "お気に入りの場所に持って行って「あとでゆっくり探検ごっこするんだ」", question: q2)

    c9  = Choice.find_or_create_by!(text: "すぐにリードを取りに行って「ねえ、今日はどこ行く？」", question: q3)
    c10 = Choice.find_or_create_by!(text: "ドアの前でおすわり「一緒にお出かけうれしいな」", question: q3)
    c11 = Choice.find_or_create_by!(text: "「今日はもう終わったよ！（頭の中で）」", question: q3)
    c12 = Choice.find_or_create_by!(text: "「もう今日は探検よりお昼寝優先かな」", question: q3)

    c13 = Choice.find_or_create_by!(text: "じーっと見つめて「どうしたらおやつがもらえるだろうか」", question: q4)
    c14 = Choice.find_or_create_by!(text: "ごろんと「動く気力はありません」", question: q4)
    c15 = Choice.find_or_create_by!(text: "必殺へそ天!「なでて～」", question: q4)
    c16 = Choice.find_or_create_by!(text: "キラキラ目で「一緒に冒険に行こう！」", question: q4)

    c17 = Choice.find_or_create_by!(text: "ブンブン全開！「いま最高にしあわせだよ！」", question: q5)
    c18 = Choice.find_or_create_by!(text: "ゆっくりふりふり「かいぬし見ているだけで幸せ」", question: q5)
    c19 = Choice.find_or_create_by!(text: "微動だにせず「しっぽも寝てるの」", question: q5)
    c20 = Choice.find_or_create_by!(text: "ピンと立って「新しい発見の予感！」", question: q5)

    # 診断結果
    d1 = Diagnosis.find_or_initialize_by(title: "ずっと見てたい…天使のまどろみモード💤")
    d1.update!(
      explanation: "「ねむねむしあわせ」
      まぶたがとろ〜ん、体もまるっとくるんと丸まって。
      夢の世界とあなたの匂いの間をふわふわ行き来しながら、しあわせを満喫中。
      たまに小さな寝言や足のピクピクで、“どんな夢見てるんだろう”って気になるくらい愛おしい。",
      dog_message: "「…Zzz（なでるのは歓迎だけど、起こさないでね）」",
      image_path: "diagnosis1.png"
      )
    d2 = Diagnosis.find_or_initialize_by(title: "ちょっと不思議でかわいすぎる。考えごとモード💭")
    d2.update!(
      explanation: "「今日のごはんは昨日より１グラム多かったな。これは原因を考えねば。」
      じーっと窓の外や空を眺めて、頭の中でいろんなシミュレーション中。
      おやつの順番、お散歩のルート、飼い主の帰宅時間まで…すべては真剣なテーマ。
      声をかけても聞こえてないくらい没頭してる姿に、思わずクスッとしちゃう。",
      dog_message: "「いま大事なこと考えてるから、あとで遊ぼ？」",
      image_path: "diagnosis2.png"
      )
    d3 = Diagnosis.find_or_initialize_by(title: "吸引力がすごい。甘えんぼモード💓")
    d3.update!(
      explanation: "「ちょっとそこに座ってて？…うん、ずっとね。」
      とにかくあなたのそばにいたい！移動すればすぐ追いかけて、
      ひざのすき間にぴったりフィット。
      しっぽはぽふぽふ、目はうるうる…
      全身からあふれる“そばにいたい”ビームが止まらない。",
      dog_message: "「ひざ、空いてる？（空いてなくても乗るけど）」",
      image_path: "diagnosis3.png"
      )
    d4 = Diagnosis.find_or_initialize_by(title: "なんか今日めちゃ元気！ハイテンションモード🐕")
    d4.update!(
      explanation: "「わーーー！楽しい！！ねえ見て見て！！」
      ごはんでジャンプ！お散歩でダッシュ！おやつでしっぽ竜巻！
      全身で「うれしい」を表現して、家中をパレードみたいに駆けまわる。
      ちょっとぶつかっちゃうくらいのパワフルさも、笑って許したくなる愛嬌のひとつ。",
      dog_message: "「おすわり？もちろんできるよ！（3秒限定）」",
      image_path: "diagnosis4.png"
      )
    d5 = Diagnosis.find_or_initialize_by(title: "未知との出会いにワクワク！冒険モード🌍")
    d5.update!(
      explanation: "「この先になにがあるのかな？クンクン…新しい発見のにおい！」
      今日は小さな探検家。ソファの下も庭の隅も、ぜんぶ冒険のフィールド。
      知らない音、知らないにおい、ぜんぶ発見のチャンス。
      気づけばあなたも一緒に冒険に巻き込まれて、楽しい時間が始まります。",
      dog_message: "「次はどっちに行く？ 一緒に探検しよう！」",
      image_path: "diagnosis5.png"
      )

    # 選択肢と診断結果を紐付け
    ChoicesDiagnosis.find_or_create_by!(choice: c1, diagnosis: d1)
    ChoicesDiagnosis.find_or_create_by!(choice: c2, diagnosis: d2)
    ChoicesDiagnosis.find_or_create_by!(choice: c3, diagnosis: d5)
    ChoicesDiagnosis.find_or_create_by!(choice: c4, diagnosis: d4)

    ChoicesDiagnosis.find_or_create_by!(choice: c5, diagnosis: d4)
    ChoicesDiagnosis.find_or_create_by!(choice: c6, diagnosis: d3)
    ChoicesDiagnosis.find_or_create_by!(choice: c7, diagnosis: d2)
    ChoicesDiagnosis.find_or_create_by!(choice: c8, diagnosis: d5)

    ChoicesDiagnosis.find_or_create_by!(choice: c9, diagnosis: d4)
    ChoicesDiagnosis.find_or_create_by!(choice: c10, diagnosis: d3)
    ChoicesDiagnosis.find_or_create_by!(choice: c11, diagnosis: d2)
    ChoicesDiagnosis.find_or_create_by!(choice: c12, diagnosis: d1)

    ChoicesDiagnosis.find_or_create_by!(choice: c13, diagnosis: d2)
    ChoicesDiagnosis.find_or_create_by!(choice: c14, diagnosis: d1)
    ChoicesDiagnosis.find_or_create_by!(choice: c15, diagnosis: d3)
    ChoicesDiagnosis.find_or_create_by!(choice: c16, diagnosis: d5)

    ChoicesDiagnosis.find_or_create_by!(choice: c17, diagnosis: d4)
    ChoicesDiagnosis.find_or_create_by!(choice: c18, diagnosis: d3)
    ChoicesDiagnosis.find_or_create_by!(choice: c19, diagnosis: d1)
    ChoicesDiagnosis.find_or_create_by!(choice: c20, diagnosis: d5)