class Conversation < ActiveRecord::Base
  # 会話はUserの概念をsenderとrecipientに分けた形でアソシエーションする。
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
  # 一つの会話はメッセージをたくさん含む一対多。
  has_many :messages, dependent: :destroy

  # [:sender_id, :recipient_id]が同じ組み合わせで保存されないようにするためのバリデーションを設定。
  validates_uniqueness_of :sender_id, scope: :recipient_id
  # validates_uniqueness_of("検証するフィールド名" [, "オプション"])

  # 下記で解説
  # scopeメソッドを使用して、「between」というスコープを定義しています。
  # validates_uniqueness_ofに書いてあるscopeとはまた違うscopeなので注意
  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end
  # これはActive Recordのスコープ（scope）を使用しています。
  # このスコープは、2人のユーザーのID（sender_idとrecipient_id）を受け取り、それらのIDを持つ会話（Conversation）を検索するクエリを定義しています。
  # このスコープは、2人のユーザーのうちどちらかが送信者で、もう一方が受信者である会話を取得します。つまり、双方向の関係にある会話を検索します。
  # WHERE句内の条件式は、OR演算子で繋がれた二つの条件文を含んでいます。
  # 一つは、「sender_idがsender_idであり、recipient_idがrecipient_idである会話」を検索し、もう一つは、「sender_idがrecipient_idであり、recipient_idがsender_idである会話」を検索します。

  # 下記で解説
  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end
end