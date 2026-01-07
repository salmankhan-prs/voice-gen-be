class VoiceGenerationMailer < ApplicationMailer
  def completed_notification(voice_generation)
    @voice_generation = voice_generation
    @audio_url = voice_generation.audio_url
    mail(to: voice_generation.notify_email, subject: "Your audio is ready! 🎙️")
  end
end
