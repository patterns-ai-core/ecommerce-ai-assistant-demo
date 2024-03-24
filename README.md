# E-commerce Store AI Assistant
Video tutorial: https://www.loom.com/share/83aa4fd8dccb492aad4ca95da40ed0b2

### Installation
1. `git clone`
2. `bundle install`
3. `export OPENAI_API_KEY=...`

### Running
```ruby
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

assistant.add_message_and_run content: "Andrei Bondarev (309485) just purchased 1 blue medium Ruby-Lovers T-shirt (Y3048509). His address is 667 Madison Avenue, New York, NY 10065", auto_tool_execution: true
assistant.add_message_and_run content: "We had just received a new inventory shipment with: B9384509: 100, X3048509: 200, K3451235: 10", auto_tool_execution: true
```
