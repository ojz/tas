pragma solidity ^0.4.4;

contract EnergyMarket {

    // company

    uint public companyPrice; // price per KW/h
    address public companyAddress;

    function EnergyMarket(uint _companyPrice) {
        companyPrice = _companyPrice;
        companyAddress = msg.sender;
    }

    function updateCompanyPrice(uint _companyPrice) {
        require(msg.sender == companyAddress);
        companyPrice = _companyPrice;        
    }

    // house

    struct House {
        uint index; // index into houseAddresses starting from 1.
        uint balanceKW; // how much energy the house has left to sell.
    }

    mapping (address => House) public houses;
    address[] public houseAddresses;

    function countHouses() returns (uint count) {
        return houseAddresses.length;
    }

    function houseExists(address houseAddress)
    returns (bool exists) {
        var house = houses[houseAddress];

        if (house.index == 0) {
            return false;
        }

        assert(houseAddresses[house.index - 1] == houseAddress);
        return true;
    }

    function createHouse(address houseAddress, uint balanceKW) {
        require(!houseExists(houseAddress));

        var index = houseAddresses.length + 1;
        var house = House(index, balanceKW);

        houses[houseAddress] = house;
        houseAddresses.push(houseAddress);
    }

    function removeHouse(address houseToDeleteAddress) {
        require(houseExists(houseToDeleteAddress));
        require(msg.sender == companyAddress || msg.sender == houseToDeleteAddress);

        var houseToDelete = houses[houseToDeleteAddress];
        var houseToTakePlaceAddress = houseAddresses[houseAddresses.length - 1];
        var houseToTakePlace = houses[houseToTakePlaceAddress];

        // put the last house in the spot of the deleted house:
        houseAddresses[houseToDelete.index - 1] = houseToTakePlaceAddress;
        houseToTakePlace.index = houseToDelete.index;

        // shrink the array and delete from the mapping
        delete houses[houseToDeleteAddress];
        houseAddresses.length--;
    }

    function addBalance(address houseAddress, uint additionalKW) {
        require(houseExists(houseAddress));
        require(msg.sender == companyAddress || msg.sender == houseAddress);

        var house = houses[houseAddress];
        house.balanceKW = house.balanceKW + additionalKW;
    }

    // sell 

    struct SellOrder {
        address owner;
        uint maxKW;
        uint priceKW;
    }

    SellOrder[] sellOrders; // unsorted

    function sellOrder(uint maxKW, uint priceKW) {
        require(houseExists(msg.sender));

        // remove from the balance of the house
        var house = houses[msg.sender];
        require(house.balanceKW >= maxKW);
        house.balanceKW = house.balanceKW - maxKW;

        // add the sellorder to the book
        SellOrder memory so = SellOrder(msg.sender, maxKW, priceKW);
        sellOrders.push(so);
    }

    function cancelSellOrder(uint index) {
        require(houseExists(msg.sender));
        
        require(sellOrders.length > index);
        var so = sellOrders[index];
        require(so.owner == msg.sender);

        // add the balance back
        var house = houses[msg.sender];
        house.balanceKW = house.balanceKW + so.maxKW;

        // remove the sell order
        sellOrders[index] = sellOrders[sellOrders.length - 1];
        sellOrders.length--;
    }

    // buy

    struct BuyOrder {
        uint companyAmount; // how much we will buy from the company.
        uint[] orders; // indices of the sell orders used.
        uint[] amounts; // amount of KW used per sell order.
    }

    BuyOrder[] buyOrders;

    function buyOrder(uint totalKW) returns (uint totalPrice) {

        // make an initial buyOrder
        var companyAmount = totalKW;
        var mostExpensivePriceUsed = companyPrice;

        uint[] orders; // both sorted by price
        uint[] amounts;

        // loop over the sellOrders, iteratively improve the buyOrder
        for (uint i = 0; i < sellOrders.length; i++) {
            var so = sellOrders[i];

            // discard orders which are too expensive
            if (so.priceKW >= mostExpensivePriceUsed) {
                continue;
            }

            // locate the position where we will insert
            var toAllocate = totalKW;
            uint position;
            for (position = 0; position < orders.length; position++) {
                var currentPrice = sellOrders[orders[position]].priceKW;
                if (currentPrice < so.priceKW) {
                    toAllocate = toAllocate - amounts[position];
                    continue;
                }
            }

            // if we reached the end, push to the arrays and subtract from companyAmount.
            if (position == orders.length - 1) {
                orders.push(i);

                var willAllocate = toAllocate > so.maxKW ? so.maxKW : toAllocate;
                amounts.push(willAllocate);

                // update how much we will need to buy from the company
                companyAmount = toAllocate - willAllocate;

                // check if we need to update the highest price we paid
                if (companyAmount == 0) {
                    mostExpensivePriceUsed = so.priceKW;
                }

                continue;
            }

            // make room for the order, moving all the more expensive orders to the right.
            orders.length++;
            amounts.length++;
            for (uint j = orders.length - 2; j > position; j--) {
                orders[j] = orders[j - 1];
                amounts[j] = amounts[j - 1];
            }

            orders[position] = i;
            amounts[position] = 0;

            // update the amounts, starting from the current
            for (; position < orders.length; position++) {
                so = sellOrders[orders[position]];

                willAllocate = toAllocate > so.maxKW ? so.maxKW : toAllocate;
                amounts[position] = willAllocate;

                toAllocate = toAllocate - willAllocate;
                if (toAllocate == 0) {
                    break;
                }
            }

            // remove all left over orders
            for (j = position + 1; j < orders.length; j++) {
                delete orders[j];
                delete amounts[j];
            }

            orders.length = position - 1;
            amounts.length = position - 1;

            // update the most expensive price used
            if (toAllocate > 0) {
                companyAmount = toAllocate;
                mostExpensivePriceUsed = companyPrice;
            } else {
                companyAmount = 0;
                mostExpensivePriceUsed = sellOrders[orders[orders.length - 1]].priceKW;
            }
        }

        // calculate the total price of the buy order
        totalPrice = companyPrice * companyAmount;
        for (i = 0; i < orders.length; i++) {
            totalPrice = totalPrice + (amounts[i] * sellOrders[orders[i]].priceKW);
        }

        // update the sell orders that we used
        for (i = 0; i < orders.length; i++) {
            var order = sellOrders[orders[i]];
            order.maxKW = order.maxKW - amounts[i];
        }

        // store the buy order
        BuyOrder memory bo = BuyOrder(companyAmount, orders, amounts);
        buyOrders.push(bo);
    }

/*
    function payBuyOrder(uint index) {
    }

    function cancelBuyOrder() {
        // put the balance back in the sell orders
        // if a sell order is closed, put it in the house.
    }
*/

    // withdraw

    mapping (address => uint) balances;

    function withdraw() {
        var amount = balances[msg.sender];

        if (amount == 0) {
            return;
        }

        balances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
}
