pragma solidity ^0.4.0;

contract Loan {
    uint public dateRequested;
    uint public dateActivated;
    uint public requestedRateBps;
    uint public requestedAmount;
    address[] public contributors;
    mapping(address => uint) public contributions;
    uint public contributedAmount;
    uint public contributorCount;
    uint public lengthInMonths;
    uint public payment;
    uint public exponentAmount;
    uint public monthlyDivide;
    uint public oneBps;


    constructor(uint _requestedRateBps, uint _requestedAmount, uint _lengthInMonths) public {
        dateRequested = now;
        requestedRateBps = _requestedRateBps;
        requestedAmount = _requestedAmount;
        lengthInMonths = _lengthInMonths;
        monthlyDivide = (requestedAmount * requestedRateBps / lengthInMonths / 10000);
        exponentAmount = (10000 + (requestedRateBps / lengthInMonths))**lengthInMonths;
        oneBps = 10000**lengthInMonths;
        payment = monthlyDivide * exponentAmount / (exponentAmount - oneBps);
    }

    function contribute() public payable {
        contributors.push(msg.sender);
        contributions[msg.sender] = msg.value;
        contributedAmount += msg.value;
        contributorCount++;
        if (contributedAmount >= requestedAmount) {
            uint excessAmount = contributedAmount - requestedAmount;
            // TODO: Need to refund excess back
            activate();
        }
    }

    function activate() private {
        dateActivated = now;
    }
}
