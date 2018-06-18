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
    uint public lengthInPeriods;
    uint public payment;
    uint public exponentAmount;
    uint public monthlyDivide;
    uint public oneBps;
    uint public numerator;
    uint public denominator;


    constructor(uint _requestedRate, uint _requestedAmount, uint _lengthInPeriods) public {
        dateRequested = now;
        // Hard coding interest for now
        // requestedRate = _requestedRate;
        requestedRate = 20;
        requestedAmount = _requestedAmount;
        lengthInPeriods = _lengthInPeriods;
        numerator = fracExp(requestedAmount, requestedRate, lengthInPeriods, 20) / requestedRate * 100000000;
        denominator = fracExp(100000000, requestedRate, lengthInPeriods, 20) - 100000000;
        payment = numerator / denominator;
    }

    function contribute() public payable {
        contributors.push(msg.sender);
        contributions[msg.sender] = msg.value;
        contributedAmount += msg.value;
        contributorCount++;
        // if (contributedAmount >= requestedAmount) {
        //     uint excessAmount = contributedAmount - requestedAmount;
        //     // TODO: Need to refund excess back
        //     activate();
        // }
    }

    function activate() private {
        dateActivated = now;
    }

    // Computes `k * (1+1/q) ^ N`, with precision `p`. The higher
    // the precision, the higher the gas cost. It should be
    // something around the log of `n`.
    // Much smaller values are sufficient to get a great approximation.
    function fracExp(uint k, uint q, uint n, uint p) returns (uint) {
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