RubyLLM.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY'] # Key for your endpoint
  config.gemini_api_key = ENV['GEMINI_API_KEY'] # Key for your Endpoint
end
