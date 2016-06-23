class Message < ActiveRecord::Base

  validates :sender_id, presence: true
  validates :recipient_id, presence: true

  belongs_to :service, foreign_key: :recipient_id
  belongs_to :user, foreign_key: :sender_id

end
