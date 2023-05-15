// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedExchange {
    mapping(address => mapping(address => uint256)) public tokenBalance;
    mapping(address => uint256) public etherBalance;

    event TokensPurchased(address indexed buyer, address indexed token, uint256 amount);
    event TokensSold(address indexed seller, address indexed token, uint256 amount);

    function buyTokens(address token, uint256 amount) public payable {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Invalid token amount");
        require(msg.value > 0, "Invalid Ether amount");

        uint256 etherAmount = msg.value;
        require(etherAmount >= amount, "Insufficient Ether amount");

        uint256 tokenAmount = amount;
        tokenBalance[token][msg.sender] += tokenAmount;
        etherBalance[msg.sender] -= etherAmount;

        emit TokensPurchased(msg.sender, token, tokenAmount);
    }

    function sellTokens(address token, uint256 amount) public {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Invalid token amount");
        require(tokenBalance[token][msg.sender] >= amount, "Insufficient token balance");

        uint256 tokenAmount = amount;
        uint256 etherAmount = tokenAmount;
        require(etherAmount > 0, "Invalid Ether amount");

        tokenBalance[token][msg.sender] -= tokenAmount;
        etherBalance[msg.sender] += etherAmount;

        emit TokensSold(msg.sender, token, tokenAmount);
    }

    function withdrawEther(uint256 amount) public {
        require(etherBalance[msg.sender] >= amount, "Insufficient Ether balance");

        uint256 etherAmount = amount;
        etherBalance[msg.sender] -= etherAmount;
        payable(msg.sender).transfer(etherAmount);
    }

    function withdrawTokens(address token, uint256 amount) public {
        require(tokenBalance[token][msg.sender] >= amount, "Insufficient token balance");

        uint256 tokenAmount = amount;
        tokenBalance[token][msg.sender] -= tokenAmount;
        // Call the ERC20 transfer function to send the tokens to the user's address
        // token.transfer(msg.sender, tokenAmount);
    }
}
