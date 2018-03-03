pragma solidity 0.4.19;

//This is a contract!
contract Donation {
    
    uint numDonations;
    struct Donate {
        address addr;
        uint projectId;
    }
    
    Donate[] donates;
    //mapping (uint => Donate) donates;
    
    // Adopting A pet
    function donate(uint projectId) public returns (uint) {
        require(projectId > 0);
        numDonations = numDonations++;

        donates[numDonations] = Donate(msg.sender, projectId);
        
        return projectId;
    }


    // Retrieving the adopters
    function getDonors() public view returns (Donate[]) {
       return donates;
    }
}