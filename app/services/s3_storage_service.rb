class S3StorageService
  def initialize
    @region = ENV.fetch("AWS_REGION")
    @bucket = ENV.fetch("AWS_BUCKET")
    @client = Aws::S3::Client.new(
      region: @region,
      access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY")
    )
  end

  def upload_audio(audio_data:, filename:)
    key = "audio/#{filename}"
    @client.put_object(bucket: @bucket, key: key, body: audio_data, content_type: "audio/mpeg")
    { success: true, url: "https://#{@bucket}.s3.#{@region}.amazonaws.com/#{key}", file_size: audio_data.bytesize }
  rescue Aws::S3::Errors::ServiceError, StandardError => e
    { success: false, error: e.message }
  end

  def delete_audio(filename:)
    @client.delete_object(bucket: @bucket, key: "audio/#{filename}")
    { success: true }
  rescue StandardError => e
    { success: false, error: e.message }
  end
end
