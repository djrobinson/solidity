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
    uint public paymentPeriodIterator;
    uint public currentPeriodIteration;
    uint public amountTilActivation;
    uint public testPeriodLength;
    bool public completeFlag;


    constructor(uint _requestedRate, uint _requestedAmount, uint _lengthInPeriods, uint _testPeriodLength) public payable {
        dateRequested = now;
        requestedRate = _requestedRate;
        requestedAmount = _requestedAmount;
        lengthInPeriods = _lengthInPeriods;
        amountTilActivation = requestedAmount;
        testPeriodLength = _testPeriodLength;
        borrower = msg.sender;
        calculatePayment();
    }

    function contribute() public payable {
        contributors.push(msg.sender);
        contributorCount++;
        if (msg.value >= amountTilActivation) {
            uint amountToRefund = msg.value - amountTilActivation;
            contributedAmount = contributedAmount + msg.value - amountToRefund;
            contributions[msg.sender] = msg.value - amountToRefund;
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

    function makePayment() public payable {
        currentPeriodIteration = (now - dateActivated) / testPeriodLength + 1;

        if (paymentPeriodIterator < currentPeriodIteration) {
            amountToInterest = calculateInterestPayment();
        }
        uint payoffValue = principalBalance + amountToInterest;
        if (msg.value <= payoffValue) {
            if (msg.value > amountToInterest && paymentPeriodIterator < currentPeriodIteration ) {
                paymentPeriodIterator++;
            }
            amountToPrincipal = msg.value - amountToInterest;
            collectedPayments += msg.value;
            principalBalance = principalBalance - msg.value - amountToInterest;
        } else {
            completeFlag = true;
            uint amountToRefund = msg.value - payoffValue;
            uint amountToPayment = msg.value - amountToRefund;
            collectedPayments += amountToPayment;
            principalBalance = 0;
            msg.sender.transfer(amountToRefund);
            distributeCollections();
        }
    }

    function distributeCollections() public {
        uint totalContributions = address(this).balance;
        for (uint i = 0; i < contributorCount; i++) {
            uint contributed = contributions[contributors[i]];
            uint distributionAmount = totalContributions * contributed / contributedAmount;
            address(contributors[i]).transfer(distributionAmount);
        }
    }


    // TODO: PMT()
    function calculatePayment() private returns (uint) {
        uint numerator = futureValue(requestedRate, lengthInPeriods, requestedAmount, 20) / requestedRate * 100000000;
        uint denominator = futureValue(requestedRate, lengthInPeriods, 100000000, 20) - 100000000;
        payment = numerator / denominator;
        return payment;
    }

    // TODO: IPMT()
    // Not right yet
    function calculateInterestPayment() private returns (uint) {
        uint interestPayment = futureValue(requestedRate, paymentPeriodIterator, payment, 20) / requestedRate;
        return interestPayment;
    }

    // TODO: FV()
    function futureValue( uint rateReciprocal, uint n, uint presentValue, uint precision) private returns (uint) {
      uint s = 0;
      uint N = 1;
      uint B = 1;
      // Might need to adjust how we set % to fraction later by changing q
      for (uint i = 0; i < precision; ++i){
        s += presentValue * N / B / (rateReciprocal**i);
        N  = N * (n-i);
        B  = B * (i+1);
      }
      return s;
    }
}