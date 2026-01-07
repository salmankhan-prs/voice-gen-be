class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle("voice_generations/create", limit: 10, period: 1.hour) do |req|
    req.ip if req.path.include?("/voice_generations") && req.post?
  end

  throttle("api/general", limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  safelist("allow localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1"
  end

  self.throttled_responder = lambda do |req|
    match_data = req.env["rack.attack.match_data"]
    retry_after = match_data[:period] - (match_data[:epoch_time] % match_data[:period])

    [429, { "Content-Type" => "application/json", "Retry-After" => retry_after.to_s },
     [{ error: "Rate limit exceeded", retry_after_seconds: retry_after }.to_json]]
  end
end
