//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract lottery {
    address public manager;
    address payable[] public participants;  //because we have to transfer eth after lottery ends to one person.

    constructor() {
        manager = msg.sender;  //global variable - currently selected account address in remix evm
        //manager will become ultimate master(not that he can change but can see the total amount) of this smart contract.
    }

    receive() external payable {    //can only be created once in smart contract
        require(msg.value == 2 ether);
        participants.push(payable(msg.sender));  //pushes address of participants who have paid in our dynamic array
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager);  //checks if we are on manager's address or not to prevent anyone from checking balance.
        return address(this).balance;

    //if hume getBalance check karna hai to jis address se deploy kiye the(manager's address) 
    //us se hi check karna padega.
    }

    function random() public view returns(uint) {
        //since this does not returns value in uint256 instead returns 64 hexadecimal characters, we have to make it return
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length))); //generates a random number
        //Iska answer bht bada aaraha hai.
        //prevrandao == difficulty
        //Dont use these in real smart contracts
    }

    function selectWinner() public {
        require(msg.sender == manager);  //Only Manager can select now.
        require(participants.length>=3);
        uint r = random();
        uint index = r % participants.length;  //Most Important Line.
        //ex-1335 % 15 => answer would be between 0 to 14 REMEMBER THIS.
        //This will help to random select the winner...abi
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());

        //Reset Participants
        participants = new address payable[](0);
    }
}