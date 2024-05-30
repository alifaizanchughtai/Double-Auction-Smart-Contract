    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract DoubleAuction {
    
    uint constant private maxSize = 20; // maximum number of bids
    uint constant private AuctionInterval = 30; // time in seconds. Contract shouldn't be called faster than this
    
    struct Bid {
        address bidder;
        uint quantity;
        uint price;
    }
    
    Bid[] public buyBids;
    Bid[] public sellBids;
    
    uint public lastAuctionTimestamp;
    
    function addBuyer(uint quantity, uint price) public {
        require(buyBids.length < maxSize, "Max buy bids reached");
        require(block.timestamp >= lastAuctionTimestamp + AuctionInterval, "Cannot add bid before the next auction interval");
        require(quantity > 0 && price > 0, "Quantity and price must be greater than zero");
        require(findBidder(msg.sender) == address(0), "Bidder already submitted a bid in this interval");
        
        buyBids.push(Bid(msg.sender, quantity, price));
    } 
    
    function addSeller(uint quantity, uint price) public {
        require(sellBids.length < maxSize, "Max sell bids reached");
        require(block.timestamp >= lastAuctionTimestamp + AuctionInterval, "Cannot add bid before the next auction interval");
        require(quantity > 0 && price > 0, "Quantity and price must be greater than zero");
        require(findBidder(msg.sender) == address(0), "Bidder already submitted a bid in this interval");
        
        sellBids.push(Bid(msg.sender, quantity, price));
    }   
    
    function doubleAuction() public {
        require(block.timestamp >= lastAuctionTimestamp + AuctionInterval, "Cannot call double auction before the next auction interval");
        
        if (buyBids.length == 0 || sellBids.length == 0) {
            return;
        }
        
        uint maxIndex = getMaxIndex();
        
        if (maxIndex == 0) {
            // No breakeven index found, reject all bids
            delete buyBids;
            delete sellBids;
            return;
        }
        
        for (uint i = 0; i < buyBids.length; i++) {
            if (i >= maxIndex) {
                delete buyBids[i];
            }
        }
        
        for (uint j = 0; j < sellBids.length; j++) {
            if (j >= maxIndex) {
                delete sellBids[j];
            }
        }
        
        lastAuctionTimestamp = block.timestamp;
    }
    
    function getResults() public view returns(address[] memory buyers, address[] memory sellers, uint[] memory quantities, uint[] memory prices) {
        buyers = new address[](buyBids.length);
        sellers = new address[](sellBids.length);
        quantities = new uint[](buyBids.length);
        prices = new uint[](buyBids.length);
        
        for (uint i = 0; i < buyBids.length; i++) {
            buyers[i] = buyBids[i].bidder;
            quantities[i] = buyBids[i].quantity;
            prices[i] = buyBids[i].price;
        }
        
        for (uint j = 0; j < sellBids.length; j++) {
            sellers[j] = sellBids[j].bidder;
        }
        
        return (buyers, sellers, quantities, prices);
    }
    
    function getMaxIndex() private view returns(uint) {
        uint maxIndex = 0;
        uint maxPrice = 0;

        for (uint i = 0; i < buyBids.length; i++) {
            if (buyBids[i].price > maxPrice) {
                maxPrice = buyBids[i].price;
            }
        }

        for (uint j = 0; j < sellBids.length; j++) {
            if (sellBids[j].price < maxPrice) {
                maxIndex = j + 1;
            }
        }

        return maxIndex;
    }
    
    function findBidder(address _address) private view returns(address) {
        for (uint i = 0; i < buyBids.length; i++) {
            if (buyBids[i].bidder == _address) {
                return _address;
            }
        }
        
        for (uint j = 0; j < sellBids.length; j++) {
            if (sellBids[j].bidder == _address) {
                return _address;
            }
        }
        
        return address(0);
    }
}
