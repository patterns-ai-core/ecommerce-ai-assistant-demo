require "openai"
require "langchain"

require_relative "./tools/inventory_management/inventory_management"
require_relative "./tools/payment_gateway/payment_gateway"
require_relative "./tools/shipping_service/shipping_service"

require "irb"
IRB.start(__FILE__)

# Create the LLM client
llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])

instructions = <<~INSTRUCTIONS
  You are an E-commerce Assistant GPT, and you are tasked with processing orders.
INSTRUCTIONS

# Create the assistant
assistant = Langchain::Assistant.new(
  # Instructions for the assistant that will be passed to OpenAI as a "system" message
  instructions: instructions,
  llm: llm,
  tools: [
    Langchain::Tool::InventoryManagement.new,
    Langchain::Tool::ShippingService.new,
    Langchain::Tool::PaymentGateway.new
  ],
  # Thread instance that will keep track and record Messages
  thread: Langchain::Thread.new
)
