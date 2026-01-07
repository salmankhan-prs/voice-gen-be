class ElevenLabsService
  BASE_URL = "https://api.elevenlabs.io/v1"

  def initialize
    @api_key = ENV.fetch("ELEVENLABS_API_KEY")
  end

  def text_to_speech(text:, voice_id:)
    response = HTTParty.post(
      "#{BASE_URL}/text-to-speech/#{voice_id}",
      headers: {
        "xi-api-key" => @api_key,
        "Content-Type" => "application/json",
        "Accept" => "audio/mpeg"
      },
      body: {
        text: text,
        model_id: "eleven_monolingual_v1",
        voice_settings: { stability: 0.5, similarity_boost: 0.5 }
      }.to_json
    )

    if response.success?
      { success: true, audio_data: response.body }
    else
      { success: false, error: parse_error(response) }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end

  def list_voices
    response = HTTParty.get("#{BASE_URL}/voices", headers: { "xi-api-key" => @api_key })
    response.success? ? { success: true, voices: response.parsed_response["voices"] } : { success: false, error: parse_error(response) }
  rescue StandardError => e
    { success: false, error: e.message }
  end

  private

  def parse_error(response)
    JSON.parse(response.body)["detail"] rescue "Unknown error (status: #{response.code})"
  end
end
