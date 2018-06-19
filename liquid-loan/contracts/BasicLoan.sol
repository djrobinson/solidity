pragma solidity ^0.4.0;

contract Loan {
    address public borrower;
    uint public dateRequested;
    uint public dateActivated;
    uint public requestedRate;
    uint public requestedAmount;
    uint public principalBalance;
    address[] public contributors;
    mapping(address => uint) public contributions;
    uint public contributedAmount;
    uint public contributorCount;
    uint public lengthInPeriods;
    uint public payment;
    uint public collectedPayments;
    uint public amountToInterest;
    uint public amountToPrincipal;
    uint public currentPeriodIterator;
    uint public amountTilActivation;
    bool public completeFlag;


    constructor(uint _requestedRate, uint _requestedAmount, uint _lengthInPeriods) public payable {
        dateRequested = now;
        requestedRate = _requestedRate;
        requestedAmount = _requestedAmount;
        lengthInPeriods = _lengthInPeriods;
        amountTilActivation = requestedAmount;
        borrower = msg.sender;
        calculatePayment();
    }

    function contribute() public payable {
        contributors.push(msg.sender);
        contributorCount++;
        if (msg.value > amountTilActivation) {
            uint amountToRefund = msg.value - amountTilActivation;
            contributedAmount = contributedAmount + msg.value - amountToRefund;
            amountTilActivation = 0;
            msg.sender.transfer(amountToRefund);
            activate();
        } else {
            contributions[msg.sender] = msg.value;
            contributedAmount += msg.value;
            amountTilActivation = amountTilActivation - msg.value;
        }
    }

    function activate() private {
        dateActivated = now;
        principalBalance = requestedAmount;
        address(borrower).transfer(address(this).balance);
    }

    function complianceCheck() public {

    }

    function makePayment() public payable {
        amountToInterest = principalBalance / requestedRate;
        uint requiredPayment = principalBalance + amountToInterest;
        if (msg.value < requiredPayment) {
            amountToPrincipal = msg.value - amountToInterest;
            collectedPayments += msg.value;
            principalBalance = principalBalance - msg.value - amountToInterest;
        } else {
            completeFlag = true;
            collectedPayments += msg.value;
            uint amountToPayment = msg.value - principalBalance;
            uint amountToRefund = amountToPayment - amountToInterest;
            collectedPayments += amountToPayment;
            principalBalance = 0;
            msg.sender.transfer(amountToRefund);
            distributeCollections();
        }
    }

    function distributeCollections() public {
        uint totalContributions = address(this).balance;
        for (uint i = 0; i < contributorCount; i++) {
            uint distributionAmount = totalContributions / contributorCount;
            address(contributors[i]).transfer(distributionAmount);
        }
    }

    function calculatePayment() private returns (uint) {
        uint numerator = fracExp(requestedAmount, requestedRate, lengthInPeriods, 20) / requestedRate * 100000000;
        uint denominator = fracExp(100000000, requestedRate, lengthInPeriods, 20) - 100000000;
        payment = numerator / denominator;
        return payment;
    }

    // Computes `k * (1+1/q) ^ N`, with precision `p`. The higher
    // the precision, the higher the gas cost. It should be
    // something around the log of `n`.
    // Much smaller values are sufficient to get a great approximation.
    function fracExp(uint k, uint q, uint n, uint p) private returns (uint) {
      uint s = 0;
      uint N = 1;
      uint B = 1;
      // Might need to adjust how we set % to fraction later by changing q
      for (uint i = 0; i < p; ++i){
        s += k * N / B / (q**i);
        N  = N * (n-i);
        B  = B * (i+1);
      }
      return s;
    }
}