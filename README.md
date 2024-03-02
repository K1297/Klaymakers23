# RealEstateToken

## Overview
RealEstateToken is a Solidity smart contract designed to facilitate the creation and management of Non-Fungible Tokens (NFTs) representing real estate properties. It extends functionalities from various Klaytn-specific contracts to provide features such as minting, purchasing, transferring, borrowing, and repaying tokens.

## Contracts Used
- `KIP37`: Implements the KIP-37 standard for Non-Fungible Tokens.
- `KIP37MetadataURI`: Extends KIP-37 to support metadata URI for tokens.
- `KIP13`: Provides support for contract introspection.

## Structure
- `RealEstateToken`: Main contract combining functionalities from the imported contracts.
- `RealEstateInfo`: Struct to store information about a real estate property.
- Various mappings to store real estate information and borrowed amounts.

## Features
1. **Minting**: Allows the creation of NFTs representing real estate properties.
2. **Purchasing**: Enables users to buy NFTs using Klaytn native tokens.
3. **Transferring**: Facilitates the transfer of NFTs between addresses.
4. **Borrowing**: Users can borrow Klaytn native tokens against the collateral of NFTs.
5. **Repaying**: Allows borrowers to repay borrowed Klaytn native tokens.

## Deployment
The contract can be deployed on the Klaytn blockchain. It requires the URI for metadata and the price of Klaytn native tokens to be provided during deployment.

## Usage
- **Minting**: Call `mint` function with appropriate parameters to create new NFTs.
- **Purchasing**: Use `purchase` function to buy NFTs by sending Klaytn native tokens.
- **Transferring**: Transfer NFTs between addresses using `transfer` function.
- **Borrowing**: Borrow Klaytn native tokens against NFT collateral via `borrow` function.
- **Repaying**: Repay borrowed Klaytn native tokens using `repay` function.

## License
This project is licensed under the MIT License.
