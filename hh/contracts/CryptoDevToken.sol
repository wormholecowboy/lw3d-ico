// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevsToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;
    uint256 public constant tokensPerNFT = 10 * 10**18;
    uint256 public constant maxTotalSupply = 10000 * 10**18;
    ICryptoDevs CryptoDevsNFT; 
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Devs Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function mint(int256 amount) public payable {
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect");
        uint256 amountWithDecimals = amount * 10**18; 
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply, "Exceeds the max total supply available"
            );
            _mint(msg.sender, amountWithDecimals);
            }

            function claim() public {
                address sender = msg.sender;
                uint256 balance = CryptoDevsNFT.balanceOf(sender);
                require(balance > 0, "You dont own any Crypto Dev NFT's");
                // keep track of number of unclaimed tokens
                uint256 amount = 0;
                for (uint256 i = 0; i < balance; i++) {
                    uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
                    // if not claimed, increment
                    if(!tokenIdsClaimed[tokenId]) {
                        amount += 1;
                        tokenIdsClaimed[tokenID] = true;
                    }
                }

                require(amount > 0, "You have already claimed all your tokens, dummy!");
                _mint(msg.sender, amount * tokensPerNFT);
            }

            receive() external payable {}
            fallback() external payable {}
}