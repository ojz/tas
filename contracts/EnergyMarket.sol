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
        uint balanceKW;
        uint priceKW;
        // uint balanceETH; // how much the owner of the house can redraw.
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

    function createHouse(address houseAddress, uint balanceKW, uint priceKW) {
        require(!houseExists(houseAddress));

        var index = houseAddresses.length + 1;
        var house = House(index, balanceKW, priceKW);

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
        houses[houseToTakePlaceAddress] = houseToTakePlace;

        // shrink the array and delete from the mapping
        delete houses[houseToDeleteAddress];
        houseAddresses.length--;
    }
}
