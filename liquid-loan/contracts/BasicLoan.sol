pragma solidity ^0.4.0;

contract Loan {
    uint public dateRequested;
    uint public dateActivated;
    uint public requestedRate;
    uint public requestedAmount;
    address[] public contributors;
    mapping(address => uint) public contributions;
    uint public contributedAmount;
    uint public contributorCount;


    constructor(uint _requestedRate, uint _requestedAmount) public {
        dateRequested = now;
        requestedRate = _requestedRate;
        requestedAmount = _requestedAmount;
    }

    function contribute() public payable {
        contributors.push(msg.sender);
        contributions[msg.sender] = msg.value;
        contributedAmount += msg.value;
        contributorCount++;
        if (contributedAmount >= requestedAmount) {
            activate();
        }
    }

    function activate() private {
        dateActivated = now;
    }
}