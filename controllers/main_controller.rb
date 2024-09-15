class MainController < Sinatra::Base
  configure do
    set :views, File.expand_path('../views', __dir__)
  end

  get '/' do
    erb :index
  end

  get '/run' do
    content_type 'text/event-stream'
    stream :keep_open do |out|
      instructions = params[:instructions]
      message = params[:message]

      assistant = Langchain::Assistant.new(
        instructions: instructions,
        llm: llm,
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

      assistant.add_message_and_run content: message, auto_tool_execution: true

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
    message.content.empty? ? message.tool_calls : message.content
  end

  def format_role(role)
    case role
    when "user"
      "👤"
    when "assistant"
      "🤖"
    when "tool"
      "🛠️"
    else
      "❓"
    end
  end

  def llm
    Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      default_options: { chat_completion_model_name: "gpt-4o-mini" }
    )
  end
end