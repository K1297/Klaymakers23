// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary libraries and interfaces
import "@klaytn/kct-contracts/contracts/token/KIP37/KIP37.sol";
import "@klaytn/kct-contracts/contracts/token/KIP37/extensions/KIP37MetadataURI.sol";
import "@klaytn/kct-contracts/contracts/utils/Context.sol";
import "@klaytn/kct-contracts/contracts/utils/Address.sol";
import "@klaytn/kct-contracts/contracts/introspection/KIP13.sol";

contract RealEstateToken is KIP37, KIP37MetadataURI, KIP13 {
    using Address for address;

    struct RealEstateInfo {
        string name;
        string description;
        uint256 price;
        uint256 totalSupply;
        string videoIPFSHash; // IPFS hash for the video stored on Pinata
    }

    // Mapping from token ID to RealEstateInfo
    mapping(uint256 => RealEstateInfo) private realEstateInfo;

    // Mapping from token ID to borrowed amount
    mapping(uint256 => uint256) private borrowedAmount;

    uint256 public klaytnNativeTokenPrice; // Price of Klaytn native token (in wei)

    constructor(string memory uri_, uint256 nativeTokenPrice) KIP37MetadataURI(uri_) {
        klaytnNativeTokenPrice = nativeTokenPrice;
    }

    // Mint NFTs with Real Estate information
    function mint(
        address to,
        uint256 tokenId,
        RealEstateInfo memory info
    ) external {
        require(info.totalSupply > 0, "Total supply must be greater than 0");
        require(info.price > 0, "Price must be greater than 0");
        require(bytes(info.videoIPFSHash).length > 0, "Video IPFS hash must be provided");
        require(!_exists(tokenId), "Token already exists");

        _mint(to, tokenId, info.totalSupply, "");
        realEstateInfo[tokenId] = info;
    }

    // Purchase NFTs
    function purchase(uint256 tokenId, uint256 amount) external payable {
        require(_exists(tokenId), "Token does not exist");
        require(msg.value == realEstateInfo[tokenId].price * amount, "Invalid amount sent");
        require(_balances[tokenId][msg.sender] + amount <= realEstateInfo[tokenId].totalSupply, "Exceeds total supply");

        _transfer(msg.sender, address(this), tokenId, amount, ""); // Corrected line

        // Distribute Klaytn native tokens (you need a method for this)
        distributeKlaytnTokens(msg.sender, realEstateInfo[tokenId].price * amount);

        // Update borrowed amount
        borrowedAmount[tokenId] += realEstateInfo[tokenId].price * amount;
    }

    // Transfer NFTs
    function transfer(address to, uint256 tokenId, uint256 amount) external {
        require(_exists(tokenId), "Token does not exist");
        _transfer(msg.sender, to, tokenId, amount, "");
    }

    // Borrow Klaytn native tokens
    function borrow(uint256 tokenId) external {
        require(_exists(tokenId), "Token does not exist");
        uint256 availableToBorrow = realEstateInfo[tokenId].price * realEstateInfo[tokenId].totalSupply - borrowedAmount[tokenId];
        require(availableToBorrow > 0, "No tokens available to borrow");

        uint256 borrowedAmountInKlaytn = availableToBorrow * klaytnNativeTokenPrice;
        require(borrowedAmountInKlaytn > 0, "Borrowed amount is too low to process");

        // Transfer Klaytn native tokens to the borrower (you need a method for this)
        transferKlaytnTokens(msg.sender, borrowedAmountInKlaytn);

        // Update borrowed amount
        borrowedAmount[tokenId] += availableToBorrow;
    }

    // Repay borrowed Klaytn native tokens
    function repay(uint256 tokenId, uint256 amount) external payable {
        require(_exists(tokenId), "Token does not exist");
        uint256 borrowedAmountInKlaytn = amount / klaytnNativeTokenPrice;
        require(borrowedAmountInKlaytn > 0, "Invalid amount sent");
        require(borrowedAmountInKlaytn <= borrowedAmount[tokenId], "Exceeds borrowed amount");

        // Transfer repaid Klaytn native tokens from the borrower (you need a method for this)
        transferKlaytnTokensFrom(msg.sender, address(this), amount);

        // Update borrowed amount
        borrowedAmount[tokenId] -= borrowedAmountInKlaytn;
    }
}
