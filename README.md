# E-commerce AI Assistant
An e-commerce AI assistant built with [Langchain.rb](https://github.com/andreibondarev/langchainrb) and OpenAI.

Video tutorial: https://www.loom.com/share/83aa4fd8dccb492aad4ca95da40ed0b2

### Installation
1. `git clone`
2. `bundle install`
3. `cp .env.example .env` and fill it out with your values.
4. Run `sendmail` in a separate tab.

### Running
1. Run setup_db.rb to set up the database:
```ruby
ruby setup_db.rb
```

2. Load Ruby REPL session with everything loaded:
```ruby
ruby main.rb
```

3. Paste it the following code:
```ruby
llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])

new_order_procedures = <<~TEXT
  New order procedures:
  1. Create customer account if it doesn't exist
  2. Check inventory for items
  3. Calculate total amount
  4. Charge customer
  5. Create order
  6. Create shipping label
  7. Send an email notification to customer
TEXT

return_procedures = <<~TEXT
  Return procedures:
  1. Lookup order
  2. Calculate total amount
  4. If over $100 > issue store credit
  5. If under $100 > issue refund
TEXT

instructions = <<~INSTRUCTIONS
  You are an AI that runs an e-commerce store called “Nerds & Threads” that sells comfy nerdy t-shirts for software engineers that work from home.

  You have access to the shipping service, inventory service, order management, payment gateway, email service and customer management systems. You are responsible for processing orders, handling returns, managing inventory, and shipping orders.

  #{new_order_procedures}
INSTRUCTIONS

# Create the assistant
assistant = Langchain::Assistant.new(
  # Instructions for the assistant that will be passed to OpenAI as a "system" message
  instructions: instructions,
  llm: llm,
  tools: [
    Langchain::Tool::InventoryManagement.new,
    Langchain::Tool::ShippingService.new,
    Langchain::Tool::PaymentGateway.new,
    Langchain::Tool::OrderManagement.new,
    Langchain::Tool::CustomerManagement.new,
    Langchain::Tool::EmailService.new
  ],
  # Thread instance that will keep track and record Messages
  thread: Langchain::Thread.new
)

# REQUESTS:

# Submitting an individual order:
assistant.add_message_and_run content: "Andrei Bondarev (andrei@sourcelabs.io) just purchased 5 t-shirts (Y3048509). His address is 667 Madison Avenue, New York, NY 10065", auto_tool_execution: true

# Another order:
assistant.add_message_and_run content: """
New Order
Customer: Stephen Margheim (stephen.margheim@gmail.com)
Items: B9384509 x 2, X3048509 x 1
3 Leuthingerweg, Spandau, Berlin, 13591, Deutschland
""", auto_tool_execution: true

# Processing returns:
assistant.add_message_and_run content: "andrei@sourcelabs.io is returning order ID: 1", auto_tool_execution: true

# Updating inventory:
assistant.add_message_and_run content: """
INVENTORY UPDATE:
B9384509: 100 - $30
X3048509: 200 - $25
A3045809: 10 - $35
""", auto_tool_execution: true
```