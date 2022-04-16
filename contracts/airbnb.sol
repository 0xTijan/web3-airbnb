// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract airbnb {

    address public owner;
    uint256 private counter;

    struct rentalInfo {
        string name;
        string city;
        string lat;
        string long;
        string unoDescription;
        string dosDescription;
        string imgUrl;
        uint256 maxGuests;
        uint256 pricePerDay;
        string[] datesBooked;
        uint256 id;
        address renter;
    }

    constructor() {
        counter = 0;
        owner = msg.sender;
    }

    event rentalCreated (
        string name,
        string city,
        string lat,
        string long,
        string unoDescription,
        string dosDescription,
        string imgUrl,
        uint256 maxGuests,
        uint256 pricePerDay,
        string[] datesBooked,
        uint256 id,
        address renter
    );
    event newDatesBooked (
        string[] datesBooked,
        uint256 id,
        address booker,
        string city,
        string imgUrl 
   );

    mapping(uint256 => rentalInfo) rentals;
    uint256[] public rentalIds;

    function addRentals(
        string memory name,
        string memory city,
        string memory lat,
        string memory long,
        string memory unoDescription,
        string memory dosDescription,
        string memory imgUrl,
        uint256 maxGuests,
        uint256 pricePerDay,
        string[] memory datesBooked
    ) public {
        require(msg.sender == owner, "Only owner of smart contract can put up rentals");
      
        rentalInfo storage newRental = rentals[counter];
        
        newRental.name = name;
        newRental.city = city;
        newRental.lat = lat;
        newRental.long = long;
        newRental.unoDescription = unoDescription;
        newRental.dosDescription = dosDescription;
        newRental.imgUrl = imgUrl;
        newRental.maxGuests = maxGuests;
        newRental.pricePerDay = pricePerDay;
        newRental.datesBooked = datesBooked;
        newRental.id = counter;
        newRental.renter = owner;

        rentalIds.push(counter);

        emit rentalCreated(
            name, 
            city, 
            lat, 
            long, 
            unoDescription, 
            dosDescription, 
            imgUrl, 
            maxGuests, 
            pricePerDay, 
            datesBooked, 
            counter, 
            owner
        );

        counter++;
    }

    // checks if booking id (apartment) free on dates inputed
    function checkBookings(uint256 id, string[] memory newBookings) private view returns (bool){
        for (uint i = 0; i < newBookings.length; i++) {
            for (uint j = 0; j < rentals[id].datesBooked.length; j++) {
                // we cant compare strings - we need to hash them first
                if (keccak256(abi.encodePacked(rentals[id].datesBooked[j])) == keccak256(abi.encodePacked(newBookings[i]))) {
                    return false;
                }
            }
        }
        return true;
    }

    function addDatesBooked(uint256 id, string[] memory newBookings) public payable {
        // check if exists, is available and if enough money has been sent
        require(id < counter, "Rental does not exist!");
        require(checkBookings(id, newBookings), "Already booked for requested dates!");
        require(msg.value == (rentals[id].pricePerDay * 1 ether * newBookings.length), "Please submited asked price!");

        // saves
        for (uint i = 0; i < newBookings.length; i++) {
            rentals[id].datesBooked.push(newBookings[i]);
        }

        // transfer funds to the renter (owner)
        payable(owner).transfer(msg.value);

        emit newDatesBooked(newBookings, id, msg.sender, rentals[id].city,  rentals[id].imgUrl);
    }

    function getRental(uint256 id) public view returns(string memory, uint256, string[] memory) {
        require(id < counter, "Rental does not exist!");

        rentalInfo storage s = rentals[id];
        return (s.name, s.pricePerDay, s.datesBooked);
    }

}