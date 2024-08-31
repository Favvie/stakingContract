// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";   
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract StakingERCToken is ReentrancyGuard {
    address owner;
    address tokenAddress;

    // the token is stored in the contract balance

    // set the owner of the contract to account calling the constructor
    // set the specific token that will be stored in the contruct
    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }


    struct Stake {
        uint amount;
        uint startTime;
        uint endTime;
        uint expectedRewards;
    }

    // a mapping that uses an address to track the stake from that address
    mapping (address => Stake) userStake;
    uint maximumDuration = 6;

    event Debug(string message);
    event StakeSuccessful(address indexed user, uint amount, uint startTime, uint endTime);
    event UnstakeSuccessful(address indexed user, uint amount, uint endTime);
    event EmergencyWithdrawalSuccessful(address indexed user, uint startTime, uint endTime, uint withdrawnAmount, uint penaltyFee);
    

    function stake(uint _amount, uint _durationInMonths) external nonReentrant {

        //check that msg.sender is not a zero address
        require(msg.sender != address(0), 'Address zero detected');

        require(userStake[msg.sender].amount == 0 || block.timestamp >= userStake[msg.sender].endTime, "You cannot stake twice. Wait till the end of staking duration.");

        require(_durationInMonths <= maximumDuration, "Maximum staking duration exceeded");


        // check that amount is not zero
        require(_amount > 0, 'You cannot stake zero');
        require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= _amount, "Insufficient token allowance");

        require(_durationInMonths > 0, "Minimum staking duration is 1 month");

        // uint durationinseconds = _durationInMonths * 30 days;
        uint durationinseconds = _durationInMonths * 1 minutes; // this duration is actually in minutes

        Stake memory newStake = Stake({
            amount: _amount,
            startTime: block.timestamp,
            endTime: block.timestamp + durationinseconds , // 30 days in seconds
            expectedRewards: calculateReward(_amount, _durationInMonths) // assuming one month of staking but normally should be calculated in the endTime key
            
        });

        userStake[msg.sender] = newStake;
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);

        emit StakeSuccessful(msg.sender, _amount, block.timestamp, block.timestamp + durationinseconds);

        
    }

    function unstake() external nonReentrant {
        require(msg.sender != address(0), "Zero address detected");

        Stake storage user = userStake[msg.sender];
        
        require(user.expectedRewards > 0, "No active stake found");

        require(block.timestamp >= user.endTime, "You cannot withdraw. Your staking duration has not ended!");

        IERC20(tokenAddress).transfer(msg.sender, user.expectedRewards);

        
        delete userStake[msg.sender];
        emit UnstakeSuccessful(msg.sender, user.expectedRewards, user.endTime);


    }

    
    // function emergencyWithdraw() external nonReentrant {

    //     emit Debug("Zero address check passed");
    //     require(msg.sender != address(0), "Zero address detected");

    //     Stake storage user = userStake[msg.sender];
        
    //     emit Debug("Active stake check passed");
    //     require(user.amount > 0, "No active stake found");

    //     emit Debug("Time check passed");
    //     require(block.timestamp < user.endTime, "Your staking duration has ended. Unstake your funds.");

    //     uint penaltyFee = (5000 * user.amount) / 100000;

    //     emit Debug("Penaltyfee calculated");

    //     IERC20(tokenAddress).transfer(msg.sender, user.amount - penaltyFee);

    //     delete userStake[msg.sender];

    //     emit EmergencyWithdrawalSuccessful(msg.sender, user.startTime, block.timestamp, user.amount - penaltyFee, penaltyFee);

    //     emit Debug('At the end of withdrawal');

    // }    

    function getMyStake() external view returns (Stake memory) {
        require(msg.sender != address(0), "Zero address detected");
        return userStake[msg.sender];
    }


    function getContractBalance() external view returns (uint) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }



    function calculateReward(uint _principal, uint _timeInMonths) public pure  returns (uint){

        uint multiplier = 100000;
        uint interest = (_principal * 5000 * _timeInMonths) / multiplier;

        return _principal + interest;

    }


}