// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract StakingEther is ReentrancyGuard {
    address owner;
    uint public minimumDuration = 1 weeks; // Minimum staking duration set to 1 week
    uint public maximumDuration = 26 weeks; // Maximum staking duration set to 6 months (26 weeks)

    constructor() payable {
        require(msg.value > 0, "Initial deposit of Ether required to fund rewards");
        owner = msg.sender;
    }

    struct Stake {
        uint amount;
        uint startTime;
        uint endTime;
        uint expectedRewards;
    }

    // Mapping to track user stakes
    mapping (address => Stake) public userStake;

    event StakeSuccessful(address indexed user, uint amount, uint startTime, uint endTime);
    event UnstakeSuccessful(address indexed user, uint amount, uint rewards);
    event EmergencyWithdrawalSuccessful(address indexed user, uint withdrawnAmount, uint penaltyFee);

    // Function to allow users to stake Ether
    function stake(uint _durationInWeeks) external payable nonReentrant {
        require(msg.sender != address(0), "Zero address detected");
        require(msg.value > 0, "You cannot stake zero Ether");
        require(userStake[msg.sender].amount == 0 || block.timestamp >= userStake[msg.sender].endTime, "You cannot stake twice. Wait till the end of staking duration.");
        require(_durationInWeeks * 1 weeks >= minimumDuration, "Staking duration is less than the minimum duration");
        require(_durationInWeeks * 1 weeks <= maximumDuration, "Staking duration exceeds the maximum duration");

        uint durationInSeconds = _durationInWeeks * 1 weeks;

        Stake memory newStake = Stake({
            amount: msg.value,
            startTime: block.timestamp,
            endTime: block.timestamp + durationInSeconds,
            expectedRewards: calculateReward(msg.value, _durationInWeeks)
        });

        userStake[msg.sender] = newStake;

        emit StakeSuccessful(msg.sender, msg.value, block.timestamp, block.timestamp + durationInSeconds);
    }

    // Function to allow users to unstake their Ether and claim rewards
    function unstake() external nonReentrant {
        require(msg.sender != address(0), "Zero address detected");
        Stake storage user = userStake[msg.sender];
        require(user.amount > 0, "No active stake found");
        require(block.timestamp >= user.endTime, "Staking period has not yet ended");

        uint amountToTransfer = user.amount + user.expectedRewards;
        user.amount = 0;

        require(address(this).balance >= amountToTransfer, "Insufficient balance in contract to pay rewards");

        (bool success, ) = msg.sender.call{value: amountToTransfer}("");
        require(success, "Transfer failed");

        emit UnstakeSuccessful(msg.sender, user.amount, user.expectedRewards);

        delete userStake[msg.sender];
    }

    // Function to allow emergency withdrawal with penalty
    function emergencyWithdraw() external nonReentrant {
        require(msg.sender != address(0), "Zero address detected");
        Stake storage user = userStake[msg.sender];
        require(user.amount > 0, "No active stake found");
        require(block.timestamp < user.endTime, "Staking period has ended, use unstake function");

        uint penaltyFee = (user.amount * 10) / 100; // 10% penalty fee
        uint amountToTransfer = user.amount - penaltyFee;

        user.amount = 0;

        require(address(this).balance >= amountToTransfer, "Insufficient balance in contract to pay withdrawal");

        (bool success, ) = msg.sender.call{value: amountToTransfer}("");
        require(success, "Transfer failed");

        emit EmergencyWithdrawalSuccessful(msg.sender, amountToTransfer, penaltyFee);

        delete userStake[msg.sender];
    }

    // Function to view the contract's Ether balance
    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }

    // Function to calculate rewards based on the staked amount and duration
    function calculateReward(uint _principal, uint _timeInWeeks) public pure returns (uint) {
        uint interestRate = 5; // 5% interest per week
        uint interest = (_principal * interestRate * _timeInWeeks) / 100;
        return interest;
    }

    // Function for the owner to withdraw contract balance (except staked funds)
    function withdrawOwnerBalance(uint _amount) external nonReentrant {
        require(msg.sender == owner, "Only the owner can withdraw");
        require(address(this).balance >= _amount, "Insufficient balance in contract");
        (bool success, ) = owner.call{value: _amount}("");
        require(success, "Withdrawal failed");
    }
}
