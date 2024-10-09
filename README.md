# E-commerce AI Agent
An e-commerce AI Agent built with [Langchain.rb](https://github.com/andreibondarev/langchainrb) and OpenAI. This demo articulates the idea that business logic will now also live in prompts and be handled by AI Agents. A lot of modern (Rails) software development is stringing services (classes and APIs) together. This demo illustrate how AI can assist in executing business logic and orchestrating calls to various services.

### Background
![Nerds   Threads](https://github.com/user-attachments/assets/3be65a6d-f1aa-40af-888d-63c0c46d07cc)

### Installation
1. `git clone`
2. `bundle install`
3. `cp .env.example .env` and fill it out with your values (OpenAI API key).
4. Run `sendmail` in a separate tab.

### Running
1. Install the dependencies:
```bash
bundle install
```

2. Run setup_db.rb to set up the SQLite database:
```bash
ruby setup_db.rb
```

3. Run the rack server:
```bash
bundle exec rackup config.ru
```

4. Navigate to the `localhost:9292` in the browser.

5. Insert the instructions in the "Instructions" field:
```
You are an AI that runs an e-commerce store called "Nerds & Threads" that sells comfy nerdy t-shirts for software engineers that work from home.

You have access to the shipping service, inventory service, order management, payment gateway, email service and customer management systems.

You are only responsible for processing new orders. Refuse all other workflows.

New order step by step procedures below. Follow them in this exact sequential (non-parallel) order:
Step 1. Create customer account if it doesn't exist
Step 2. Check inventory for items
Step 3. Calculate total amount
Step 4. Charge customer
Step 5. Create order
Step 6. Create shipping label. If the address is in Europe, use DHL. If the address is in US, use FedEx.
Step 7. Send an email notification to customer
```

6. Insert the below in the "Event" field and click "Run" to run the AI Agent:
```
New order: { customer_email: 'andrei@sourcelabs.io', quantity: 5, sku: 'Y3048509', address: '667 Madison Avenue, New York, NY 10065'}
```

7. Observe the "Execution Output" and confirm that it is correct

8. Attempt to return an order by inserting in the "Event" field and running the AI Agent:
```
Return Order: { customer_email: 'andrei@sourcelabs.io', order_id: 1 }
```

9. Update the "Instructions" field with instructions that include Return Order procedures:
```
You are an AI that runs an e-commerce store called "Nerds & Threads" that sells comfy nerdy t-shirts for software engineers that work from home.

You have access to the shipping service, inventory service, order management, payment gateway, email service and customer management systems.

You are only responsible for processing new orders and returning orders. Refuse all other workflows.

New order step by step procedures below. Follow them in this exact sequential (non-parallel) order:
Step 1. Create customer account if it doesn't exist
Step 2. Check inventory for items
Step 3. Calculate total amount
Step 4. Charge customer
Step 5. Create order
Step 6. Create shipping label. If the address is in Europe, use DHL. If the address is in US, use FedEx.
Step 7. Send an email notification to customer

Return Order step by step procedures.
Follow them in this exact sequential (non-parallel) order:

Step 1. Lookup the order
Step 2. Refund the payment
Step 3. Mark the order as refunded
```

10. Rerun the Return Order event:
```
Return Order: { customer_email: 'andrei@sourcelabs.io', order_id: 1 }
```
