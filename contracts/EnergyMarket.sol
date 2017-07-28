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
/*
    struct SellOrder {
        uint maxKW;
        uint priceKW;
    }

    mapping (address => SellOrder[]) sellOrders;

    function sellOrder(uint maxKW, uint priceKW) {
        require(houseExists(msg.sender));
        SellOrder storage sellOrder;
        sellOrder = SellOrder(maxKW, priceKW);

        if (sellOrders[msg.sender].length > 0) {
            sellOrders[msg.sender].push(sellOrder);
        } else {
            sellOrders[msg.sender] = [sellOrder];
        }
    }

    function cancelSellOrder(address owner, uint index) {
        require(houseExists(owner));
        require(msg.sender == companyAddress || msg.sender == owner);
    }

    // buy

    struct BuyOrder {
        address[] storage from;
        uint[] storage amount;
    }

    function buy() returns (uint index, uint totalPrice) {
        // make an initial buyOrder
        // loop over the houseAddresses
        // iteratively improve the buyOrder
    }

    function pay(uint index) {
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
