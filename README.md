# Staking Contracts

This repository contains two staking contracts:

1. **Ether Staking Contract**: Allows users to stake Ether for rewards.
2. **ERC20 Staking Contract**: Allows users to stake a specific ERC20 token for rewards.

Both contracts allow users to stake their assets for a specified duration to earn rewards. Users can withdraw their staked assets and rewards after the staking period ends, or they can opt for an emergency withdrawal with a penalty.

## Table of Contents

- [Staking Contracts](#staking-contracts)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Ether Staking Contract](#ether-staking-contract)
      - [Deployment](#deployment)
      - [Key Functions](#key-functions)
    - [ERC20 Staking Contract](#erc20-staking-contract)
      - [Deployment](#deployment-1)
      - [Key Functions](#key-functions-1)
  - [Security Considerations](#security-considerations)
  - [License](#license)

## Features

- **Staking**: Stake Ether or ERC20 tokens for a specified duration to earn rewards.
- **Rewards Calculation**: Rewards are based on the staking duration and the amount staked.
- **Unstaking**: Withdraw staked assets and rewards after the staking period ends.
- **Emergency Withdrawal**: Withdraw staked assets before the staking period ends, with a penalty.
- **Security**: The contracts include reentrancy protection to ensure secure transfers.

## Requirements

- Solidity `^0.8.0`
- OpenZeppelin Contracts
  - `IERC20` (for the ERC20 staking contract)
  - `ReentrancyGuard`

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/StakingContracts.git
   cd StakingContracts
   ```

2. **Install dependencies**:
   ```bash
   npm install @openzeppelin/contracts
   ```

3. **Compile the contracts**:
   ```bash
   npx hardhat compile
   ```

## Usage

### Ether Staking Contract

#### Deployment

Deploy the contract without any parameters:

```solidity
constructor() {
    owner = msg.sender;
}
```

#### Key Functions

- **`stake()`**: Stake Ether for a set duration.
- **`unstake()`**: Withdraw staked Ether and rewards after the staking period ends.
- **`emergencyWithdraw()`**: Withdraw staked Ether before the staking period ends, with a penalty.
- **`getMyStake()`**: View details of the caller's stake.
- **`getContractBalance()`**: Check the total Ether balance held by the contract.
- **`calculateReward(uint _principal, uint _timeInMonths)`:** Calculate the potential reward based on the principal and duration.

### ERC20 Staking Contract

#### Deployment

Deploy the contract by specifying the address of the ERC20 token you want to use for staking:

```solidity
constructor(address _tokenAddress) {
    owner = msg.sender;
    tokenAddress = _tokenAddress;
}
```

#### Key Functions

- **`stake(uint _amount, uint _durationInMonths)`:** Stake a specific amount of ERC20 tokens for a set duration.
- **`unstake()`**: Withdraw staked tokens and rewards after the staking period ends.
- **`emergencyWithdraw()`**: Withdraw staked tokens before the staking period ends, with a penalty.
- **`getMyStake()`**: View details of the caller's stake.
- **`getContractBalance()`**: Check the total balance of ERC20 tokens held by the contract.
- **`calculateReward(uint _principal, uint _timeInMonths)`:** Calculate the potential reward based on the principal and duration.

## Security Considerations

- **Reentrancy Protection**: Both contracts use `ReentrancyGuard` from OpenZeppelin to prevent reentrancy attacks.
- **Secure Transfers**: The ERC20 contract uses the `IERC20` interface for secure token transfers.


## License

This project is licensed under the MIT License.
