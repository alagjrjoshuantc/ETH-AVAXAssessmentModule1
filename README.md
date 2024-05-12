# Donation Handling

This Solidity program is designed to handle donations with an implementation of `require()`, `assert()`, and `revert()` statements for error handling and state validation. The purpose of this program is to demonstrate how to manage transactions, donations, and refunds securely on the Ethereum blockchain.

## Description

This smart contract allows users to deposit, donate, and request refunds within set parameters to ensure transactions do not exceed preset limits. It employs Solidity's error-handling capabilities to maintain the integrity and constraints of the donations system. This contract serves as an excellent example for developers looking to understand transaction management and error handling in blockchain applications.

## Getting Started

### Executing program

To execute this program, you'll need an environment that can compile and deploy Solidity smart contracts, such as Remix IDE.

1. Visit the Remix IDE at [https://remix.ethereum.org/](https://remix.ethereum.org/).
2. Create a new file in the IDE named `DonationHandling.sol`.
3. Copy and paste the provided Solidity code into this new file.
4. Compile the code by selecting the correct compiler version (`0.8.18`) in the Solidity Compiler tab and then clicking on "Compile DonationHandling.sol".
5. Deploy the contract in the "Deploy & Run Transactions" tab by selecting "Injected Web3" and using a compatible Ethereum wallet like MetaMask.
6. Once deployed, interact with the contract functions like `deposit`, `donate`, `refund`, and `checkInvariants` through the Remix interface.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DonationHandling {
    uint256 public totalDonations;
    uint256 private totalRefunded;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public donated;

    uint256 public constant MAX_DONATIONS = 100;  // Maximum allowable donations
    uint256 public constant MAX_REFUND = 50;      // Maximum allowable refunds
    uint256 public constant MAX_DEPOSIT = 100;    // Maximum deposit amount per transaction

    event DonationReceived(uint256 amount, address donor);
    event RefundIssued(uint256 amount, address recipient);
    event DepositMade(uint256 amount, address depositor);

    function deposit(uint256 _amount) public {
        require(_amount > 0, "Deposit must be greater than 0.");
        require(_amount <= MAX_DEPOSIT, "Deposit exceeds the maximum allowed.");
        balances[msg.sender] += _amount;
        emit DepositMade(_amount, msg.sender);
    }

    function donate(uint256 _amount) public {
        require(_amount >= 1 && _amount <= 50, "Donation must be between 1 and 50.");
        require(balances[msg.sender] >= _amount, "Insufficient balance to donate.");
        if (totalDonations + _amount > MAX_DONATIONS) {
            revert("Donation cap reached, donation not accepted.");
        }
        balances[msg.sender] -= _amount;
        donated[msg.sender] += _amount;
        totalDonations += _amount;
        emit DonationReceived(_amount, msg.sender);
    }

    function refund(uint256 _amount) public {
        require(donated[msg.sender] >= _amount, "Insufficient donated amount for refund.");
        require(_amount <= 25, "Refund amount cannot exceed 25.");
        if (totalRefunded + _amount > MAX_REFUND) {
            revert("Total refund cap exceeded.");
        }
        donated[msg.sender] -= _amount;
        balances[msg.sender] += _amount;
        totalDonations -= _amount;
        totalRefunded += _amount;
        emit RefundIssued(_amount, msg.sender);
    }

    function checkInvariants() public view {
        assert(totalDonations >= 0 && totalDonations <= MAX_DONATIONS);
        assert(totalRefunded <= MAX_REFUND);
    }
}
```


## Authors

NTCIAN Josh
<br>
[Discord: @Range](https://discordapp.com/users/Range#4932)

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
