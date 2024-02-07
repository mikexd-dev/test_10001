// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FriendTech is ERC20 {
    address private owner;
    uint private sharePrice;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() ERC20("FriendTech", "FT") {
        owner = msg.sender;
        sharePrice = 0;
    }

    function setSharePrice(uint price) external onlyOwner {
        sharePrice = price;
    }

    function getSharePrice() external view returns (uint) {
        return sharePrice;
    }

    function setTotalSupply(uint totalSupply) external onlyOwner {
        require(totalSupply > 0, "Total supply must be greater than zero");
        _mint(msg.sender, totalSupply);
    }

    function buyShares(uint amount) external payable {
        require(amount > 0, "Amount must be greater than zero");
        require(msg.value == amount * sharePrice, "Incorrect amount of ether sent");

        _mint(msg.sender, amount);
    }

    function sellShares(uint amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount * sharePrice);
    }

    function transferShares(address recipient, uint amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _transfer(msg.sender, recipient, amount);
    }
}