// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract LotteryUpgradeable is Initializable,OwnableUpgradeable {
    
    struct TicketHolder {
        address _holderAddress; //20bytes
        uint _numTickets;
    }

    mapping (address => uint) public ticketHolders;
    address[] public holders;

    // Array of previous winners.
    // TODO: Only hold last 10 winners
    address[] public prevWinners;

    // Winner of the current lottery
    address public winner;

    // Total number of tickets issued
    uint public ticketsIssued;

    // Total balance of the smart contract
    uint public contractBalance;

    // When the lottery started
    uint public lotteryStart;

    // Duration the lottery will be active for
    uint public lotteryDuration;

    // Flag that the lottery is now over
    bool public lotteryEnded;

    // Total Eth that has been won from users using the contract
    uint public totalEthWon;

    //----------Events---------------
    // Event for when tickets are bought
    event TicketsBought(address indexed _from, uint _quantity);

    // Event for declaring the winner
    event AwardWinnings(address _to, uint _winnings);

    // Event for lottery reset
    event ResetLottery();

    //---------Modifiers---------------

    // Checks if still in lottery contribution period
    modifier lotteryOngoing() {
        require(block.timestamp < lotteryStart + lotteryDuration);
        _;
    }

    // Checks if lottery has finished
    modifier lotteryFinished() {
        require(block.timestamp > lotteryStart + lotteryDuration);
        _;
    }

    //---------Functions----------------
    
    //Create the lottery, each one lasts for 24 hours
    function initialize() external initializer {
        ticketsIssued = 0;
        lotteryStart = block.timestamp;
        lotteryDuration = 5 minutes;
    }

    // Fallback function calls buyTickets
    receive() external payable {
    }

    // Award users tickets for eth, 1 finney = 1 ticket
    function buyTickets(uint256 number) payable public lotteryOngoing returns (bool success) {
        ticketHolders[msg.sender] = number;
        ticketsIssued += ticketHolders[msg.sender];
        holders.push(msg.sender);
        contractBalance += msg.value;
        emit TicketsBought(msg.sender, ticketHolders[msg.sender]);
        return true;
    }

    // After winners have been declared and awarded, clear the arrays and reset the balances
    function resetLottery() internal lotteryFinished returns (bool success) {
        lotteryEnded = false;
        lotteryStart = block.timestamp;
        lotteryDuration = 24 hours;
        emit ResetLottery();
        return true;
    }

    // This will distribute the correct winnings to each winner
    function awardWinnings(address _winner) internal lotteryOngoing returns (bool success) {
        payable(_winner).transfer(contractBalance);
        emit AwardWinnings(_winner, contractBalance);
        contractBalance = 0;
        resetLottery();
        return true;
    }

    //Generate the winners by random using tickets bought as weight
    function generateWinners() public lotteryFinished returns (uint winningTicket) {

        //Need to make this truly random - This is temp solution for testing
        uint randNum = uint(block.number - 1) % ticketsIssued + 1;
        winner = holders[randNum];
        prevWinners.push(winner);
        awardWinnings(winner);
        return randNum;
    }

    function getTicketBalance(address _account) public view returns (uint balance) {
        return ticketHolders[_account];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function addTicketHolder(uint256 number) payable public lotteryOngoing returns (bool success) {
        ticketHolders[msg.sender] = number;
        ticketsIssued += ticketHolders[msg.sender];
        holders.push(msg.sender);
        contractBalance += msg.value;
        emit TicketsBought(msg.sender, ticketHolders[msg.sender]);
        return true;
    }

}