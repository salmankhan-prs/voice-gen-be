module Api
  module V1
    class VoiceGenerationsController < BaseController
      def index
        render json: VoiceGeneration.recent.limit(50)
      end

      def show
        render json: VoiceGeneration.find(params[:id])
      end

      def create
        voice_generation = VoiceGeneration.new(voice_generation_params)

        if voice_generation.save
          GenerateVoiceJob.perform_later(voice_generation.id)
          render json: voice_generation, status: :created
        else
          render json: { errors: voice_generation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def voice_generation_params
        params.require(:voice_generation).permit(:text, :voice_id, :notify_email)
      end
    end
  end
end
