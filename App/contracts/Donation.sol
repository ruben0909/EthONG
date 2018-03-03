pragma solidity 0.4.19;

//This is a contract!
contract Donation {
    address[16] public donors;

    // Donate to project
    function donate(uint projectId) public returns (uint) {
        require(projectId >= 0 && projectId <= 15);

        donors[projectId] = msg.sender;

        return projectId;
        }


        // Retrieving the donors
        function getDonors() public view returns (address[16]) {
            return donors;
        }
}