class MainController < Sinatra::Base
  configure do
    set :views, File.expand_path('../views', __dir__)
    set :protection, except: [:json_csrf]
  end

  before do
    content_type :json
    headers 'Access-Control-Allow-Origin' => '*',
             'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
  end

  options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    200
  end

  get '/' do
    content_type :html
    erb :index
  end

  get '/run' do
    content_type 'text/event-stream'
    headers 'X-Accel-Buffering' => 'no' # This line is for NGINX compatibility
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
          Langchain::Tool::Database.new(connection_string: ENV["DATABASE_URL"])          
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