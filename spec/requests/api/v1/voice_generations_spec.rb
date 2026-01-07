require "rails_helper"

RSpec.describe "Api::V1::VoiceGenerations", type: :request do
  describe "GET /api/v1/voice_generations" do
    it "returns voice generations" do
      create(:voice_generation)
      get "/api/v1/voice_generations"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(1)
    end
  end

  describe "GET /api/v1/voice_generations/:id" do
    it "returns the voice generation" do
      vg = create(:voice_generation)
      get "/api/v1/voice_generations/#{vg.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(vg.id)
    end

    it "returns 404 for non-existent id" do
      get "/api/v1/voice_generations/99999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/voice_generations" do
    let(:valid_params) { { voice_generation: { text: "Hello", voice_id: "abc123" } } }

    it "creates a voice generation and queues job" do
      expect {
        post "/api/v1/voice_generations", params: valid_params
      }.to change(VoiceGeneration, :count).by(1)
        .and have_enqueued_job(GenerateVoiceJob)

      expect(response).to have_http_status(:created)
    end

    it "returns 422 with invalid params" do
      post "/api/v1/voice_generations", params: { voice_generation: { text: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
