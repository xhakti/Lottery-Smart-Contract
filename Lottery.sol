// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; 

contract Lottery { 

    //************************* STATE VARIABLES *******************************
    //Manager 
        // contract deployer becomes the manager 
        // only used to pick the winner
        // can not enter lottery 

    address public manager; 
   
    //Players/Participants;
        // array of payable participants 
    
    address payable[] public players; 
    
    
    // ********************************* CONSTRUCTOR **************************
    constructor (){
        manager = msg.sender;
            }
    
    // ********************************* FUNCTIONS **************************
  
    /// @notice Enter the lottery
    function enterLottery() payable public 
    {
        // other player is required than manager 
        require(msg.sender != manager,"## MANAGER CAN NOT ENTER THE LOTTERY ##");
        // player is required to only enter once 
        for (uint i = 0; i < players.length ;i ++){
            require (msg.sender != players[i],"## YOU HAVE ALREADY ENTERED THE LOTTERY ##");
        }
        // entry balance should be more than 1 ether. 
        require(msg.value >= 1 ether, "## PLEASE ENTER THE MINIMUM AMOUNT (1 ether) FOR LOTTERY ##");
        // players get added in the lottery 
        players.push(payable(msg.sender));
    }


    ///@notice Random num is generated for winner selection
    function random() private view returns(uint)
    {
        // gives a random number uing the sha256 variable 
        return uint(sha256(abi.encodePacked(block.timestamp, block.difficulty, players)));
    }


    /// @notice Pick Winner 
    function pickWinner() public 
    {
        // manager is required to call the function 
        require(msg.sender == manager, "## ONLY MANAGER CAN PICK THE WINNER ##");
        // player no is require to be more than 3 players 
        require(players.length >= 3, "## MORE PARTICIPANTS ARE REQUIRED TO PICK THE WINNER ##");
        //  random function to get a random winner
        // index for random selection using random
        address payable winner;
        uint index = random() % players.length;
        winner = players[index];
        // Transfer the contract funds to the winner 
        uint LotteryAmount = address(this).balance;
        winner.transfer(LotteryAmount);

        // will reset the lottery
        players = new address payable[](0);
    
    }


    /// @notice This will show the Lotter Amount to the users
    function Lottery_Amount() public view returns(uint)
    {
        uint lottryAmt;
        lottryAmt += uint(address(this).balance);
        return lottryAmt ;
    }

    
    /// @notice This function will show the total no of participant in the smart contract 
    function TotalPlayers() public view returns (uint Total_Players){
        Total_Players = players.length;
    }



}