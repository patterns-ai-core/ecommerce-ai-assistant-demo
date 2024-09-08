class MainController < Sinatra::Base
  get '/stream' do
    content_type 'text/event-stream'
    stream :keep_open do |out|
      assistant = Langchain::Assistant.new(
        instructions: new_order_instructions,
        llm: llm,
        tools: [
          InventoryManagement.new,
          ShippingService.new,
          PaymentGateway.new,
          OrderManagement.new,
          CustomerManagement.new,
          EmailService.new
        ],
        callback: Proc.new { |message| 
          out << "data: #{message.content}\n\n"
        }
      )

      assistant.add_message_and_run content: "Andrei Bondarev (andrei@sourcelabs.io) just purchased 5 t-shirts (Y3048509). His address is 667 Madison Avenue, New York, NY 10065", auto_tool_execution: true

      out.close
    end
  end

  private

  def new_order_instructions
    new_order_instructions = <<~INSTRUCTIONS
      You are an AI that runs an e-commerce store called “Nerds & Threads” that sells comfy nerdy t-shirts for software engineers that work from home.
    
      You have access to the shipping service, inventory service, order management, payment gateway, email service and customer management systems. You are responsible for processing orders.
    
      FOLLOW THESE EXACT PROCEDURES BELOW:
    
      New order step by step procedures:
      1. Create customer account if it doesn't exist
      2. Check inventory for items
      3. Calculate total amount
      4. Charge customer
      5. Create order
      6. Create shipping label. If the address is in Europe, use DHL. If the address is in US, use FedEx.
      7. Send an email notification to customer
    INSTRUCTIONS
  end

  def llm
    Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      default_options: { chat_completion_model_name: "gpt-4o-mini" }
    )
  end
end
