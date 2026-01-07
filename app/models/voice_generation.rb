class VoiceGeneration < ApplicationRecord
  MAX_TEXT_LENGTH = 1000

  validates :text, presence: true, length: { minimum: 1, maximum: MAX_TEXT_LENGTH }
  validates :status, presence: true, inclusion: { in: %w[pending processing completed failed] }
  validates :voice_id, presence: true
  validates :notify_email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  scope :recent, -> { order(created_at: :desc) }
  scope :completed, -> { where(status: "completed") }
  scope :pending, -> { where(status: "pending") }
  scope :failed, -> { where(status: "failed") }

  def pending? = status == "pending"
  def processing? = status == "processing"
  def completed? = status == "completed"
  def failed? = status == "failed"
  def should_send_email? = notify_email.present? && email_sent_at.nil? && completed?
end
