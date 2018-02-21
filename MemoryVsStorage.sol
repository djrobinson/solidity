pragma solidity ^0.4.17;

contract Numbers {
  int[] public memoryNumbers;
  int[] public storageNumbers;

  function Numbers() public {
    memoryNumbers.push(20);
    memoryNumbers.push(32);
    storageNumbers.push(20);
    storageNumbers.push(32);

    int[] memory memoryArray = memoryNumbers;
    memoryArray[0] = 1;
    int[] storage storageArray = storageNumbers;
    storageArray[0] = 1;
  }
}


/*
  Notes on Solidity Mappings:
  1. keys are not stored (it's a hash table)
  2. Values are not iterable (due to #1)
  3. All values exist (never get an undefined)
*/