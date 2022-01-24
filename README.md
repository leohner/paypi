# PayPI
PayPI (pronounce pay-pea-eye) is a prototype system for handling API calls.

## Purpose
This purpose of this pull request is to handle basic API functionality. However, it should be noted that this is a work in progress and is meant to generate interest in creating comprehensive APIs.

The program makes the assumption that the intent of a request has already been parsed and we know the intent. From there were are able to fork into the functions below.

## Functions
There are five main functions in PayPI:
- Create Order
- Get Order by Order ID
- Get Orders by Customer Email
- Pay an Existing Order
- Create a New Order and Apply Payment

## Features
There are two critical features built into PayPI:
- Idempotency is included through the use of a payment key to prevent the same payment from submitting multiple times.
- When creating a new order and applying payment, should there be any server errors between the creation of the order and the creation of the payment, the order will be deleted so it will not persist in memory. The payment will not be registered. 

Lesser features include:
- Conversion of strings to numbers when applicable. For instance, if customer_id is submitted as a string, PayPI will work to convert it to an integer. The same goes for payment and order values, except to floats instead of integers.

## Usage
The application is used by running the `Paypi.run` function with values specified in a tuple.

### Create Order
`mix run -e "Paypi.run({:create_order, customer_id, order_amount})"`

- `:create_order` is the action parsed from the request.
- `customer_id` is the id of the customer for which we're creating an order.
- `order_amount` is the amount the order is for.

### Get Order
`mix run -e "Paypi.run({:get_order, order_id})"`

- `:get_order` is the action parsed from the request.
- `order_id` is the order id for which we're getting details.

### Get Orders
`mix run -e "Paypi.run({:get_orders, \"email\"})"`

- `:get_orders` is the action parsed from the request.
- `email` is the email for which we're getting orders. Note that it the quotes around it are escaped. This is necessary.

### Pay
`mix run -e "Paypi.run({:pay, order_id, amount, payment_key})"`

- `:pay` is the action parsed from the request.
- `order_id` is the order we want to apply a payment to.
- `amount` is the payment amount we want to apply to the order.
- `payment_key` is a unique identifier used for idempotency.

### Create and Pay
`mix run -e "Paypi.run({:create_pay, customer_id, order_amount, payment_amount, payment)key})"`

- `:create_pay` is the action parsed from the request.
- `customer_id` is the id of the customer for which we're creating an order.
- `order_amount` is the amount of the order.
- `payment_amount` is the amount to be applied to order.
- `payment_key` is a unique identifier used for idempotency.


## Future Improvements
Aside from general cleanup of code, adding comments, and refactoring; I'd like to factor in rounding when accounting for amounts. Currently it just accepts any float.


## Additional Notes
I would like to note that this only the second application I have built in Elixir, the first being a console-based todo app, which can be seen on my github as well. And that one I only put together on the 17th of January, 2022. 

Being a newcomer to the Elixir language, I am certain there are many conventions that I am unaware of. I want this prototype to demonstrate my genuine interest and passion for the language and my dedication to improving myself. 

I will say that this exercise took more than 4 hours. However, that time was an investment, as I learned so much more about the language and how to use it, and that was my goal. TThe skills I've acquired will pay dividends and will make further developments easier.

Things I've learned through this include:
- using Agent to store state
- using Ecto and a SQLite Adapter to learn in-language database functionality
- handling complicated and nested function calls

Things I feel like I need to improve:
- using function return values appropriately
- writing more concise and maintainable code, and I know that comes with practice
- much of the code could stand to be refactored. The Get module was used early on in the development of this feature, but it was made redundant by the Data module
- I know for a fact I need to add test cases; given the time restraints though I had to settle for basic functional testing (albeit without the black-box). Being able to write effective tests is definitely a goal.
- Documenting the code is a necessity. That would absolutely be the next step in order to facilitate its use.

