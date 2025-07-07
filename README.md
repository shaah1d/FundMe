# FundMe - Decentralized Crowdfunding Contract

A simple crowdfunding smart contract where people can donate ETH, but with a twist - it enforces a minimum donation of $5 USD using real-time price data from Chainlink.

## What it does

This contract lets people send ETH donations, but it automatically converts the ETH amount to USD to make sure each donation is at least $5. No more worrying about ETH price fluctuations affecting your minimum donation amount!

**Key features:**
- **$5 minimum donation** enforced in real-time
- **Owner can withdraw** all collected funds
- **Works on multiple networks** (Sepolia testnet and local development)
- **Automatic price conversion** using Chainlink Price Feeds

## How it works

1. **Donate**: Users call `fund()` with ETH - contract checks if it's worth at least $5
2. **Track**: Contract keeps track of who donated and how much
3. **Withdraw**: Only the contract owner can withdraw all the funds
4. **Convert**: Uses Chainlink to get current ETH/USD price for accurate conversions

## Technical stuff

**Main contracts:**
- `FundMe.sol` - The main crowdfunding contract
- `PriceConverter.sol` - Library that handles ETH to USD conversion
- `HelperConfig.s.sol` - Manages different network configurations
- `MockV3Aggregator.sol` - Fake price feed for testing

**Networks supported:**
- **Sepolia testnet** - Uses real Chainlink price feed
- **Local Anvil** - Uses mock price feed (set to $2000/ETH)

## Current Test Coverage Report

| File                            | % Lines        | % Statements   | % Branches    | % Functions    |
|---------------------------------|----------------|----------------|---------------|----------------|
| `script/DeployFundMe.s.sol`     | **0.00%** (0/7)  | **0.00%** (0/9)  | **100.00%** (0/0) | **0.00%** (0/1)  |
| `script/HelperConfig.s.sol`     | **0.00%** (0/13) | **0.00%** (0/11) | **0.00%** (0/2)  | **0.00%** (0/3)  |
| `src/Fundme.sol`                | **85.71%** (24/28) | **91.30%** (21/23) | **80.00%** (4/5) | **80.00%** (8/10) |
| `src/PriceConverter.sol`        | **100.00%** (7/7)  | **100.00%** (8/8)  | **100.00%** (0/0) | **100.00%** (2/2)  |
| `test/mocks/MockAgreegatorv3.sol` | **52.17%** (12/23) | **52.94%** (9/17) | **100.00%** (0/0) | **50.00%** (3/6)  |
| **Total**                       | **55.13%** (43/78) | **55.88%** (38/68) | **57.14%** (4/7) | **59.09%** (13/22) |

## Security features

- **Only owner can withdraw** - Uses custom `NotOwner()` error for gas efficiency
- **Automatic donations** - Has `receive()` and `fallback()` functions so people can just send ETH directly
- **Price feed verification** - Checks that the price feed is working during deployment
- **Comprehensive testing** - Unit tests, integration tests, and mock testing

## Built with

- **Solidity ^0.8.18** - Smart contract language
- **Foundry** - Development framework
- **Chainlink Price Feeds** - For getting real ETH/USD prices
- **Custom libraries** - For clean, reusable code

