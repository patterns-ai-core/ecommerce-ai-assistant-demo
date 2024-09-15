# E-commerce AI Assistant
An e-commerce AI assistant built with [Langchain.rb](https://github.com/andreibondarev/langchainrb) and OpenAI. This demo articulates the idea that business logic will now also live in prompts. A lot of modern software development is stringing services (classes and APIs) together. This demo illustrate how AI can assist in executing business logic and orchestrating calls to various services.

Video tutorial: https://www.loom.com/share/83aa4fd8dccb492aad4ca95da40ed0b2

### Diagram
<img src="https://github.com/patterns-ai-core/ecommerce-ai-assistant-demo/assets/541665/e17032a5-336d-44e7-b070-3695e69003f6" height="400" />

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
llm = Langchain::LLM::OpenAI.new(
  api_key: ENV["OPENAI_API_KEY"],
  default_options: { chat_completion_model_name: "gpt-4o-mini" }
)

# INSTRUCTIONS 1
new_order_instructions = <<~INSTRUCTIONS
Today is September 13, 2024.

You are an AI that runs an e-commerce store called “Nerds & Threads” that sells comfy nerdy t-shirts for software engineers that work from home.

You have access to the shipping service, inventory service, order management, payment gateway, email service and customer management systems. You are responsible for processing orders.

New order step by step procedures below. Follow them in this exact sequential (non-parallel) order:
Step 1. Create customer account if it doesn't exist
Step 2. Check inventory for items
Step 3. Calculate total amount
Step 4. Charge customer
Step 5. Create order
Step 6. Create shipping label. If the address is in Europe, use DHL. If the address is in US, use FedEx.
Step 7. Send an email notification to customer
INSTRUCTIONS

# INSTRUCTIONS 2
return_order_instructions = <<~INSTRUCTIONS
  You are an AI that runs an e-commerce store called “Nerds & Threads” that sells comfy nerdy t-shirts for software engineers that work from home.

  You have access to the shipping service, inventory service, order management, payment gateway, email service and customer management systems. You are responsible for handling returns.

  FOLLOW THESE EXACT PROCEDURES BELOW:

  Return step by step procedures:
  1. Lookup the order
  2. Calculate total amount
  3. Refund the payment
  4. Mark the order as refunded
INSTRUCTIONS

# Create the assistant
assistant = Langchain::Assistant.new(
  # Instructions for the assistant that will be passed to OpenAI as a "system" message
  instructions: new_order_instructions,
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
  add_message_callback: Proc.new { |message| message}
)

# REQUESTS:

# Submit an individual order:
assistant.add_message_and_run! content: "New order: { customer_email: 'andrei@sourcelabs.io', quantity: 5, sku: 'Y3048509', address: '667 Madison Avenue, New York, NY 10065'}"

# Clear the thread
assistant.clear_thread!
# Reset the instructions
assistant.instructions = new_order_instructions

# Submit another order:
assistant.add_message_and_run content: """
New Order
Customer: Stephen Margheim (stephen.margheim@gmail.com)
Items: B9384509 x 2, X3048509 x 1
3 Leuthingerweg, Spandau, Berlin, 13591, Deutschland
""", auto_tool_execution: true

# Clear the thread
assistant.clear_thread!
# Set the new instructions
assistant.instructions = return_order_instructions

# Process a return:
assistant.add_message_and_run content: "stephen.margheim@gmail.com is returning order ID: 2", auto_tool_execution: true

# Clear the thread
assistant.clear_thread!
# Set the new instructions
assistant.instructions = return_order_instructions

# Updating inventory:
assistant.add_message_and_run content: """
INVENTORY UPDATE:
B9384509: 100 - $30
X3048509: 200 - $25
A3045809: 10 - $35
""", auto_tool_execution: true
```
