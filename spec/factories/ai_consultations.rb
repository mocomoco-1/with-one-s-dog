FactoryBot.define do
  factory :ai_consultation do
    association :user
    category { "散歩中の吠え" }
    situation { "他の犬とすれ違うとき" }
    dog_reaction { "吠えて引っ張る" }
    goal { "落ち着いて散歩できるようにしたい" }
    details { "短い距離から練習したい" }
    initial_response {
      {
        "summary" => "犬が散歩中に吠える悩みです。",
        "empathy" => "頑張っていますね🐶",
        "advice" => {
          "short_term" => [ "距離をとる", "ほめる", "短い散歩から始める" ],
          "long_term" => [ "社会化トレーニングを行う", "ポジティブ強化を続ける" ]
        },
        "cheer" => "応援しています✨"
      }
    }
  end
end
