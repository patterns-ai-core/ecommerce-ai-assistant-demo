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
          EmailService.new
        ],
        add_message_callback: Proc.new { |message|
          format_message(message)

          out << "data: #{format_message(message)}\n\n"
        }
      )

      assistant.add_message_and_run content: message, auto_tool_execution: true

      out.close
    end
  end

  private

  def format_message(message)
    "#{format_role(message.role)}: #{format_content(message)}"
  end

  def format_content(message)
    if message.content.empty?
      message.tool_calls
    else
      message.content
    end
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
      role
    end
  end

  def llm
    Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      default_options: { chat_completion_model_name: "gpt-4o-mini" }
    )
  end
end
