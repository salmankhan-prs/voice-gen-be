FactoryBot.define do
  factory :voice_generation do
    text { "Hello, this is a test." }
    status { "pending" }
    voice_id { "21m00Tcm4TlvDq8ikWAM" }

    trait :completed do
      status { "completed" }
      audio_url { "https://test-bucket.s3.amazonaws.com/audio/123.mp3" }
      completed_at { Time.current }
    end

    trait :failed do
      status { "failed" }
      error_message { "API error" }
    end

    trait :with_email do
      notify_email { "test@example.com" }
    end
  end
end
