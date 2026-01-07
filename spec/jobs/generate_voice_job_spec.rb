require "rails_helper"

RSpec.describe GenerateVoiceJob, type: :job do
  let(:eleven_labs) { instance_double(ElevenLabsService) }
  let(:s3_storage) { instance_double(S3StorageService) }
  let(:pusher) { instance_double(PusherService) }

  before do
    allow(ElevenLabsService).to receive(:new).and_return(eleven_labs)
    allow(S3StorageService).to receive(:new).and_return(s3_storage)
    allow(PusherService).to receive(:new).and_return(pusher)
    allow(pusher).to receive(:notify_processing)
    allow(pusher).to receive(:notify_completed)
    allow(pusher).to receive(:notify_failed)
  end

  it "processes voice generation successfully" do
    vg = create(:voice_generation)
    allow(eleven_labs).to receive(:text_to_speech).and_return({ success: true, audio_data: "audio" })
    allow(s3_storage).to receive(:upload_audio).and_return({ success: true, url: "https://test.com/audio.mp3", file_size: 1000 })

    GenerateVoiceJob.perform_now(vg.id)
    vg.reload

    expect(vg.status).to eq("completed")
    expect(vg.audio_url).to be_present
  end

  it "handles ElevenLabs API failure" do
    vg = create(:voice_generation)
    allow(eleven_labs).to receive(:text_to_speech).and_return({ success: false, error: "API error" })
    allow(s3_storage).to receive(:upload_audio)

    GenerateVoiceJob.perform_now(vg.id)
    vg.reload

    expect(vg.status).to eq("failed")
    expect(vg.error_message).to eq("API error")
  end

  it "skips already completed voice generations" do
    vg = create(:voice_generation, :completed)
    allow(eleven_labs).to receive(:text_to_speech)

    GenerateVoiceJob.perform_now(vg.id)

    expect(eleven_labs).not_to have_received(:text_to_speech)
  end
end
