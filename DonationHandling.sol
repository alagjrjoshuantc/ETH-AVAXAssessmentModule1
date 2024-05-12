// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Write a smart contract that implements the require(), assert() and revert() statements.

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
