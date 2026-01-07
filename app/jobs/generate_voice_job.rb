class GenerateVoiceJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform(voice_generation_id)
    voice_generation = VoiceGeneration.find(voice_generation_id)
    return if voice_generation.completed? || voice_generation.failed?

    eleven_labs = ElevenLabsService.new
    s3_storage = S3StorageService.new
    pusher = PusherService.new

    begin
      voice_generation.update!(status: "processing")
      pusher.notify_processing(voice_generation)

      audio_result = eleven_labs.text_to_speech(text: voice_generation.text, voice_id: voice_generation.voice_id)
      unless audio_result[:success]
        handle_failure(voice_generation, pusher, audio_result[:error])
        return
      end

      filename = "#{voice_generation.id}_#{Time.current.to_i}.mp3"
      upload_result = s3_storage.upload_audio(audio_data: audio_result[:audio_data], filename: filename)
      unless upload_result[:success]
        handle_failure(voice_generation, pusher, upload_result[:error])
        return
      end

      voice_generation.update!(
        status: "completed",
        audio_url: upload_result[:url],
        file_size_bytes: upload_result[:file_size],
        completed_at: Time.current
      )
      pusher.notify_completed(voice_generation)

      if voice_generation.should_send_email?
        VoiceGenerationMailer.completed_notification(voice_generation).deliver_later
        voice_generation.update!(email_sent_at: Time.current)
      end
    rescue StandardError => e
      handle_failure(voice_generation, pusher, e.message)
      raise e
    end
  end

  private

  def handle_failure(voice_generation, pusher, error_message)
    voice_generation.update!(status: "failed", error_message: error_message)
    pusher.notify_failed(voice_generation)
  end
end
