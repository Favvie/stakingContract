# ERC20 Staking Smart Contract

This project implements a simple ERC20 staking contract, allowing users to stake a specific ERC20 token in exchange for rewards. The rewards are calculated based on the duration of the staking period. The contract includes functionalities for staking, unstaking, and emergency withdrawal, ensuring secure and efficient handling of ERC20 token transfers.

## Table of Contents

- [ERC20 Staking Smart Contract](#erc20-staking-smart-contract)
  - [Table of Contents](#table-of-contents)
- [ERC20 Staking Smart Contract](#erc20-staking-smart-contract-1)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Deployment](#deployment)
    - [Key Functions](#key-functions)
  - [Security Considerations](#security-considerations)
  - [Testing](#testing)
  - [License](#license)
  - [Introduction](#introduction)
  - [Features](#features-1)
  - [Requirements](#requirements)
  - [Installation](#installation-1)
  - [Usage](#usage-1)
    - [Deployment](#deployment-1)
    - [Contract Overview](#contract-overview)
      - [Stake](#stake)
      - [Unstake](#unstake)
      - [Emergency Withdrawal](#emergency-withdrawal)
      - [View Functions](#view-functions)
    - [Security Considerations](#security-considerations-1)
    - [Testing](#testing-1)
  - [License](#license-1)

---

# ERC20 Staking Smart Contract

This project implements a staking smart contract that allows users to stake a specific ERC20 token in exchange for rewards. The rewards are calculated based on the duration of the staking period. Users can withdraw their staked tokens and rewards after the staking period ends, or they can opt for an emergency withdrawal with a penalty.

## Features

- **Staking**: Stake ERC20 tokens for a specified duration to earn rewards.
- **Rewards Calculation**: Rewards are based on the staking duration and amount staked.
- **Unstaking**: Withdraw staked tokens and rewards after the staking period ends.
- **Emergency Withdrawal**: Withdraw staked tokens before the staking period ends, with a penalty.
- **Security**: The contract includes reentrancy protection to ensure secure token transfers.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/ERC20StakingContract.git
   cd ERC20StakingContract
   ```

2. **Install dependencies**:
   ```bash
   npm install @openzeppelin/contracts
   ```

3. **Compile the contract**:
   ```bash
   npx hardhat compile
   ```

## Usage

### Deployment

Deploy the contract by specifying the address of the ERC20 token you want to use for staking:

```solidity
constructor(address _tokenAddress) {
    owner = msg.sender;
    tokenAddress = _tokenAddress;
}
```

### Key Functions

- **`stake(uint _amount, uint _durationInMonths)`:** Stake a specific amount of ERC20 tokens for a set duration.
- **`unstake()`:** Withdraw staked tokens and rewards after the staking period ends.
- **`emergencyWithdraw()`:** Withdraw staked tokens before the staking period ends, with a penalty.
- **`getMyStake()`:** View details of the caller's stake.
- **`getContractBalance()`:** Check the total balance of ERC20 tokens held by the contract.
- **`calculateReward(uint _principal, uint _timeInMonths)`:** Calculate the potential reward based on the principal and duration.

## Security Considerations

- **Reentrancy Protection**: Uses `ReentrancyGuard` from OpenZeppelin to prevent reentrancy attacks.
- **ERC20 Transfers**: Secure handling of ERC20 token transfers using the standard `IERC20` interface.

## Testing

- **Unit Tests**: Ensure all functions work as expected by writing comprehensive unit tests.
- **Deployment Tests**: Test the contract on a testnet to validate its behavior in a live environment.
- **Security Audits**: Consider performing a security audit to identify and mitigate potential vulnerabilities.

## License

This project is licensed under the MIT License.

---

You can directly copy and paste this into your `README.md` file. It provides a clear overview of your project, including installation instructions, usage, and key features, while also addressing security considerations and licensing.
- [ERC20 Staking Smart Contract](#erc20-staking-smart-contract)
  - [Table of Contents](#table-of-contents)
- [ERC20 Staking Smart Contract](#erc20-staking-smart-contract-1)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Deployment](#deployment)
    - [Key Functions](#key-functions)
  - [Security Considerations](#security-considerations)
  - [Testing](#testing)
  - [License](#license)
  - [Introduction](#introduction)
  - [Features](#features-1)
  - [Requirements](#requirements)
  - [Installation](#installation-1)
  - [Usage](#usage-1)
    - [Deployment](#deployment-1)
    - [Contract Overview](#contract-overview)
      - [Stake](#stake)
      - [Unstake](#unstake)
      - [Emergency Withdrawal](#emergency-withdrawal)
      - [View Functions](#view-functions)
    - [Security Considerations](#security-considerations-1)
    - [Testing](#testing-1)
  - [License](#license-1)

## Introduction

The ERC20 Staking Smart Contract allows users to stake a specific ERC20 token for a predetermined period. The longer the tokens are staked, the higher the rewards. Users can withdraw their staked tokens along with rewards after the staking period ends, or they can opt for an emergency withdrawal before the staking period ends, which incurs a penalty.

## Features

- **Staking:** Users can stake a specific amount of ERC20 tokens for a selected duration.
- **Rewards Calculation:** Rewards are calculated based on the amount staked and the duration of the staking period.
- **Unstaking:** Users can withdraw their staked tokens and rewards after the staking duration ends.
- **Emergency Withdrawal:** Allows users to withdraw their tokens before the staking duration ends with a penalty.
- **Secure Transfers:** All ERC20 token transfers are handled securely and efficiently.
- **Prevent Reentrancy Attacks:** The contract uses the `ReentrancyGuard` to prevent reentrancy attacks.

## Requirements

- Solidity `^0.8.0`
- OpenZeppelin Contracts
  - `IERC20`
  - `ReentrancyGuard`

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/ERC20StakingContract.git
   cd ERC20StakingContract
   ```

2. **Install dependencies:**
   Ensure you have OpenZeppelin Contracts installed in your project. You can install them via npm:

   ```bash
   npm install @openzeppelin/contracts
   ```

3. **Compile the contract:**
   If using Hardhat, run:

   ```bash
   npx hardhat compile
   ```

## Usage

### Deployment

Deploy the contract using a development environment like Hardhat, Truffle, or Remix. Ensure you specify the address of the ERC20 token contract during deployment:

```solidity
constructor(address _tokenAddress) {
    owner = msg.sender;
    tokenAddress = _tokenAddress;
}
```

### Contract Overview

#### Stake

The `stake` function allows users to stake a specified amount of ERC20 tokens for a set duration (in months).

```solidity
function stake(uint _amount, uint _durationInMonths) external nonReentrant
```

#### Unstake

The `unstake` function allows users to withdraw their staked tokens along with rewards after the staking period has ended.

```solidity
function unstake() external nonReentrant
```

#### Emergency Withdrawal

The `emergencyWithdraw` function allows users to withdraw their staked tokens before the staking period ends, but with a penalty.

```solidity
function emergencyWithdraw() external nonReentrant
```

#### View Functions

- **`getMyStake()`**: Returns the details of the caller’s stake.
- **`getContractBalance()`**: Returns the total balance of the ERC20 tokens held by the contract.
- **`calculateReward()`**: A public view function that calculates the reward based on the principal and duration.

### Security Considerations

- **Reentrancy Protection:** The contract utilizes OpenZeppelin's `ReentrancyGuard` to prevent reentrancy attacks.
- **Input Validation:** The contract validates user input to ensure that staking amounts and durations are within acceptable limits.
- **ERC20 Token Handling:** The contract uses the standard `IERC20` interface for secure token transfers.

### Testing

1. **Unit Tests:** Write unit tests to verify the contract's functionality, including edge cases for staking, unstaking, and emergency withdrawals.
2. **Deployment Tests:** Deploy the contract on a test network to verify that it behaves as expected in a real environment.
3. **Security Audits:** Consider having the contract audited by a third-party security firm to identify any potential vulnerabilities.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
