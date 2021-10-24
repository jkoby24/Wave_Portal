// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    constructor() payable {
        console.log("Making contract payable");
    }

    uint256 totalWaves;
    //state variable used to generate random number
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; //address of the user who waved
        string message; //message the user sent
        uint256 timestamp; //timestamp of the user wave
    }
    //stores an array of structs. This will hold all the waves anyone ever send to me
    Wave[] waves;

    //Address with the last time the user waved at us. Each address will be paired with a number
    mapping(address => uint256) public lastWavedAt;

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 40 seconds < block.timestamp,
            "Please wait 40 seconds before you can wave again"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved at you!", msg.sender);
        //stores new wave into an array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        uint256 randomNumber = (block.difficulty + block.timestamp + seed) %
            100;
        console.log("Random # generated: %s", randomNumber);

        seed = randomNumber;

        if (randomNumber < 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than avaiable in contract"
            );
            (bool sucess, ) = (msg.sender).call{value: prizeAmount}(" ");
            require(sucess, "Failed to withdraw money from contract.");
        }

        //
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    // returns the struct array
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
