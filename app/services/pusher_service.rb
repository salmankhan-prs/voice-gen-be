class PusherService
  def initialize
    @client = Pusher::Client.new(
      app_id: ENV.fetch("PUSHER_APP_ID"),
      key: ENV.fetch("PUSHER_KEY"),
      secret: ENV.fetch("PUSHER_SECRET"),
      cluster: ENV.fetch("PUSHER_CLUSTER"),
      encrypted: true
    )
    @channel = ENV.fetch("PUSHER_CHANNEL", "voice-gen-updates")
  end

  def notify_completed(voice_generation)
    trigger("voice_completed", {
      id: voice_generation.id,
      status: voice_generation.status,
      audio_url: voice_generation.audio_url,
      text: voice_generation.text,
      duration_seconds: voice_generation.duration_seconds,
      completed_at: voice_generation.completed_at
    })
  end

  def notify_failed(voice_generation)
    trigger("voice_failed", {
      id: voice_generation.id,
      status: voice_generation.status,
      error_message: voice_generation.error_message,
      text: voice_generation.text
    })
  end

  def notify_processing(voice_generation)
    trigger("voice_processing", { id: voice_generation.id, status: voice_generation.status })
  end

  private

  def trigger(event_name, data)
    @client.trigger(@channel, event_name, data)
    { success: true }
  rescue Pusher::Error, StandardError => e
    Rails.logger.error("Pusher error: #{e.message}")
    { success: false, error: e.message }
  end
end
