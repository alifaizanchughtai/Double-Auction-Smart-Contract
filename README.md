# Double Auction Smart Contract

This Solidity smart contract implements a double auction mechanism, allowing buyers and sellers to submit bids for a particular asset. The contract matches buy bids with sell bids based on their prices and quantities, aiming to find a mutually acceptable price for both buyers and sellers.

## Features

### 1. Double Auction Mechanism
   - **Buy Bids**: Buyers can submit bids specifying the quantity they want to buy and the price they are willing to pay.
   - **Sell Bids**: Sellers can submit bids specifying the quantity they want to sell and the price they are asking for.
   - **Auction Interval**: Bids are processed periodically based on a predefined auction interval.

### 2. Bid Management
   - **Maximum Bid Limit**: The contract enforces a maximum limit on the number of bids that can be submitted.
   - **Unique Bidder Check**: Each bidder can only submit one bid per auction interval.
   - **Bid Removal**: After each auction, bids that are not matched are removed from the system.

### 3. Auction Execution
   - **Matching Bids**: The contract matches buy bids with sell bids based on their prices and quantities.
   - **Price Discovery**: The auction aims to find a clearing price where the maximum buy price matches the minimum sell price.
   - **Efficient Auction Execution**: The contract efficiently processes bids to minimize gas costs and ensure fair execution.

### 4. Result Retrieval
   - **Get Auction Results**: The contract provides a function to retrieve the results of the auction, including the addresses of buyers and sellers, quantities, and prices.
