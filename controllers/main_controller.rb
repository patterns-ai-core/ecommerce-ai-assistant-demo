# frozen_string_literal: true

class MainController < Sinatra::Base
  configure do
    set :views, File.expand_path('../views', __dir__)
    enable :sessions
  end

  get '/' do
    erb :index
  end

  get '/run' do
    content_type 'text/event-stream'
    stream :keep_open do |out|
      instructions = params[:instructions]
      message = params[:message]

      session[:assistant] ||= Langchain::Assistant.new(
        instructions: instructions,
        llm: llm,
	parallel_tool_calls: false,
        tools: [
          InventoryManagement.new,
          ShippingService.new,
          PaymentGateway.new,
          OrderManagement.new,
          CustomerManagement.new,
          EmailService.new,
          Langchain::Tool::Database.new(connection_string: "sqlite://#{ENV["DATABASE_NAME"]}")
        ],
        add_message_callback: Proc.new { |message|
          out << "data: #{JSON.generate(format_message(message))}\n\n"
        }
      )
      # Rewrite instructions in case they changed.
      session[:assistant].instructions = instructions

      # Append new message and run with auto_tool_execution: true
      session[:assistant].add_message_and_run! content: message

      out << "event: done\ndata: Stream finished\n\n"
      out.close
    end
  end

  private

  def format_message(message)
    {
      role: message.role,
      content: format_content(message),
      emoji: format_role(message.role)
    }
  end

  def format_content(message)
    message.content.empty? ? message.tool_calls.first.dig("function") : message.content
  end

  def format_role(role)
    case role
    when "user"
      "👤"
    when "assistant"
      "🤖"
    when "tool", "tool_result"
      "🛠️"
    else
      "❓"
    end
  end


  def openai_llm
    Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      default_options: { chat_completion_model_name: "gpt-4o-mini" }
    )
  end

  def gemini_llm
    Langchain::LLM::GoogleGemini.new(
      api_key: ENV["GOOGLE_GEMINI_API_KEY"],
      default_options: { chat_completion_model_name: "gemini-1.5-pro" }
    )
  end

  def anthropic_llm
    Langchain::LLM::Anthropic.new(
      api_key: ENV["ANTHROPIC_API_KEY"],
      default_options: { chat_completion_model_name: "claude-2" }
    )
  end

  # Auto-choosing LLM based on ENV variables being available.
  def llm
    Langchain.logger.level = Logger::INFO

    return openai_llm if ENV.fetch 'OPENAI_API_KEY', false
    return gemini_llm if ENV.fetch 'GOOGLE_GEMINI_API_KEY', false
    return anthropic_llm if ENV.fetch 'ANTHROPIC_API_KEY', false
    raise "I need at least one key among OPENAI_API_KEY, GOOGLE_GEMINI_API_KEY, and ANTHROPIC_API_KEY"
  end

end
