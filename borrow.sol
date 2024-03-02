// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract RWA {
    struct NftData {
        address owner;
        uint256 value;
        uint256 borrowed;
    }

    IERC721 public nftContract;
    
    mapping(uint256 => NftData) public nfts;

    constructor(address _nftAddress) {
        nftContract = IERC721(_nftAddress);
    }

    function depositNft(uint256 nftId, uint256 value) public {
        // Transfer the NFT to this contract
        nftContract.transferFrom(msg.sender, address(this), nftId);
        
        // Record the NFT's data
        nfts[nftId] = NftData(msg.sender, value, 0);
    }

    function borrow(uint256 nftId) public {
        // Check that the NFT is owned by the sender and they haven't already borrowed the maximum amount
        require(nfts[nftId].owner == msg.sender && nfts[nftId].borrowed < nfts[nftId].value * 80 / 100, "Cannot borrow");

        // Update the borrowed amount
        nfts[nftId].borrowed = nfts[nftId].value * 80 / 100;

        // Transfer the borrowed amount to the sender
        payable(msg.sender).transfer(nfts[nftId].borrowed);
    }

    function repay(uint256 nftId) public payable {
        // Check that the NFT is owned by the sender and they have borrowed the correct amount
        require(nfts[nftId].owner == msg.sender && msg.value == nfts[nftId].borrowed, "Cannot repay");

        // Update the borrowed amount
        nfts[nftId].borrowed = 0;
    }

    function withdrawNft(uint256 nftId) public {
        // Check that the NFT is owned by the sender and they have repaid any borrowed amount
        require(nfts[nftId].owner == msg.sender && nfts[nftId].borrowed == 0, "Cannot withdraw");

        // Transfer the NFT back to the sender
        nftContract.transferFrom(address(this), msg.sender, nftId);
        
        // Remove the NFT's data
        delete nfts[nftId];
    }
}
