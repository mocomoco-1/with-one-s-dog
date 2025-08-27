question1 = Question.find_or_create_by!(text: "わんこ、今どこで何してる？")
question2 = Question.find_or_create_by!(text: "ごはんを出すと、どんな顔をする？")
question3 = Question.find_or_create_by!(text: "お散歩の気配を感じたときは？")
question4 = Question.find_or_create_by!(text: "飼い主と目が合った時のリアクションは？")
question5 = Question.find_or_create_by!(text: "しっぽ、今どんな感じ？")

choice1 = Choice.find_or_create_by!(text: "ひざの上でぬくぬく…「ここがいちばん安心する」", question: question1)
choice2 = Choice.find_or_create_by!(text: "部屋のすみっこでなんかやってる「えっほえっほ」", question: question1)
choice3 = Choice.find_or_create_by!(text: "窓の外をじーっと見つめて、「今日も警備のお仕事頑張ります」", question: question1)
choice4 = Choice.find_or_create_by!(text: "おうちの中を駆けまわりながら、「わーーーーん！！」", question: question1)

choice5 = Choice.find_or_create_by!(text: "くるくる回って走って興奮Max!", question: question2)
choice6 = Choice.find_or_create_by!(text: "そっと近づいてお座り。「おりこうさんだからください！」", question: question2)
choice7 = Choice.find_or_create_by!(text: "じーっと見つめて固まる「いつもより少なくないですか、、」", question: question2)
choice8 = Choice.find_or_create_by!(text: "お気に入りの場所に持って行って、「あとでこっそり楽しむんだ〜」", question: question2)

choice9 = Choice.find_or_create_by!(text: "すぐにリードを取りに行って、「ねえ、今日はどこ行く？」", question: question3)
choice10 = Choice.find_or_create_by!(text: "ドアの前でおすわりして、「準備できてるよ、いつでもOK!」", question: question3)
choice11 = Choice.find_or_create_by!(text: "「今日はもう終わったよ！（頭のなかで）」", question: question3)
choice12 = Choice.find_or_create_by!(text: "「もう今日は寝ます」", question: question3)

choice13 = Choice.find_or_create_by!(text: "ニコッと笑ってしっぽぶんぶん、「かいぬし大好き！！」", question: question4)
choice14 = Choice.find_or_create_by!(text: "ごろんと「動く気力はありません」", question: question4)
choice15 = Choice.find_or_create_by!(text: "必殺へそ天!「なでて～」", question: question4)
choice16 = Choice.find_or_create_by!(text: "ちょっと目をそらして、「照れくさいけど、うれしいの」", question: question4)

choice17 = Choice.find_or_create_by!(text: " ブンブン全開！「いま最高にしあわせだよ！」", question: question5)
choice18 = Choice.find_or_create_by!(text: "  ゆっくりふりふり「ここにいられることがうれしいの」", question: question5)
choice19 = Choice.find_or_create_by!(text: "微動だにせず「しっぽも寝てるの」", question: question5)
choice20 = Choice.find_or_create_by!(text: "しっぽ行方不明中、、、「どこかなしっぽ」", question: question5)


diagnosis1 = Diagnosis.find_or_create_by!(title: "ずっと見てたい…天使のまどろみモード", explanation: "  「ここが天国ですか？…いいえ、飼い主のそばです。」
  今日はとろ〜んとした瞳、まるまった体、しあわせのかたまり状態。
  そっと寝息をたてながら、たまにちらっと目を開けてあなたを確認してるかも。
  世界でいちばん愛おしい“ぬくもりのかたまり”が、今ここに。", dog_message: "「…Zzz（なでるのは歓迎だけど、起こさないでね）」")
diagnosis2 = Diagnosis.find_or_create_by!(title: "ちょっと不思議でかわいすぎる。考えごとモード", explanation: "  「おさんぽの順路を再構築しています。AIじゃないけどね！」
  窓の外を見つめたり、風のにおいをくんくんしたり…。
  きっと、今日のおやつの順番か、昨日のカラスの動きについて考えてます。
  背中に「しーっ」って貼り紙したくなるくらい、集中してるのがまたかわいい。", dog_message: "「さっき思いついた“最短おやつルート”、いつか話すね。」")
diagnosis3 = Diagnosis.find_or_create_by!(title: "吸引力がすごい。甘えんぼモード", explanation: "  「べつにずっとそばにいたいとか、言ってないけど…ずっとそばにいるね。」
  気づくとすぐそば。
  移動するとちょっと後ろをついてきて、しっぽがぽふぽふ…。
  そんな“無言の愛情ビーム”に、あなたの心もとろけちゃう。", dog_message: "「ひざ、空いてる？（空いてなくても乗るけど）」")
diagnosis4 = Diagnosis.find_or_create_by!(title: "なんか今日めちゃ元気！ハイテンションモード", explanation: "  このパワー、もはやターボ搭載。」
  ごはん見て走り、リード見てジャンプ、おやつ見てしっぽ竜巻！
  今日はなにかと全力投球な日。テンションが家具にもぶつかってるかも。
  でも、その元気、すべて“うれしい気持ち”のあらわれなんです。", dog_message: "「おすわり？もちろんできるよ!（5秒限定）」")
diagnosis5 = Diagnosis.find_or_create_by!(title: "まさかの集中力。職人モード", explanation: "  「だれにも気づかれず、毛布を芸術的に丸めるという使命がある」
  一見マイペース。でもその行動にはちゃんと理由がある。
  ごはんの隠し場所、ベストお昼寝角度、毎日研究中。
  何も語らない背中に、「世界観」を感じる、そんな一日。", dog_message: "「毛布を丸めるのに、10年かけてるんだよ？」")

ChoicesDiagnosis.find_or_create_by!(choice: choice1, diagnosis: diagnosis1)
ChoicesDiagnosis.find_or_create_by!(choice: choice2, diagnosis: diagnosis2)
ChoicesDiagnosis.find_or_create_by!(choice: choice3, diagnosis: diagnosis5)
ChoicesDiagnosis.find_or_create_by!(choice: choice4, diagnosis: diagnosis4)
ChoicesDiagnosis.find_or_create_by!(choice: choice5, diagnosis: diagnosis4)
ChoicesDiagnosis.find_or_create_by!(choice: choice6, diagnosis: diagnosis3)
ChoicesDiagnosis.find_or_create_by!(choice: choice7, diagnosis: diagnosis2)
ChoicesDiagnosis.find_or_create_by!(choice: choice8, diagnosis: diagnosis5)
ChoicesDiagnosis.find_or_create_by!(choice: choice9, diagnosis: diagnosis4)
ChoicesDiagnosis.find_or_create_by!(choice: choice10, diagnosis: diagnosis3)
ChoicesDiagnosis.find_or_create_by!(choice: choice11, diagnosis: diagnosis2)
ChoicesDiagnosis.find_or_create_by!(choice: choice12, diagnosis: diagnosis1)
ChoicesDiagnosis.find_or_create_by!(choice: choice13, diagnosis: diagnosis4)
ChoicesDiagnosis.find_or_create_by!(choice: choice14, diagnosis: diagnosis1)
ChoicesDiagnosis.find_or_create_by!(choice: choice15, diagnosis: diagnosis3)
ChoicesDiagnosis.find_or_create_by!(choice: choice16, diagnosis: diagnosis5)
ChoicesDiagnosis.find_or_create_by!(choice: choice17, diagnosis: diagnosis4)
ChoicesDiagnosis.find_or_create_by!(choice: choice18, diagnosis: diagnosis3)
ChoicesDiagnosis.find_or_create_by!(choice: choice19, diagnosis: diagnosis1)
ChoicesDiagnosis.find_or_create_by!(choice: choice20, diagnosis: diagnosis5)
