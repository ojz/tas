pragma solidity ^0.4.4;

contract EnergyMarket {

    uint public companyPrice; // price per KW/h
    address companyAddress;

    function EnergyMarket(uint _companyPrice) {
        companyPrice = _companyPrice;
        companyAddress = msg.sender;
    }

    function getCompanyPrice() returns (uint price) {
        price = companyPrice;
    }

    //

    struct House {
        bool exists;
        uint balance; // KW
    }

    mapping (address => House) houses;

    function houseExists()
    returns (bool exists) {
        var house = houses[msg.sender];
        exists = house.exists;
    }

    /*

    function createHouse() {
        var house = House(true, 0);
        houses[msg.sender] = house;
    }
    
    //

	/*
	
	function createOffer(uint price, uint total) {
	    var offer = Offer(msg.sender, price, total);
	    offers.push(offer);
	}
	
	//
	
	function numOffers()
	returns (
	    uint total
    ) {
	    total = offers.length;
	}
	
	function getOffer(uint idx)
	returns (
	    address owner,
	    uint price,
	    uint total
    ) {
        var offer = offers[idx];
        owner = offer.owner;
        price = offer.price;
        total = offer.total;
	}

    //*/


}
