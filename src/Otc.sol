// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// TODO: add rbac / ownership

type Exposure is uint256;
type Price is uint256;

contract Otc is Ownable {
    string public greeting = "Hello World";

    enum side {
        Buy,
        Sell
    }

    struct Quote {
        address token;
        uint256 size;
        uint256 price; // TODO: figure out how to handle price (ex: in wei per token unit)
        bool accepted;
        // TODO: add expiration
    }

    ERC20[] public tokens;
    Quote[] public quotes;

    // wallet => token => balance
    mapping(address => mapping(address => Exposure)) public exposure;

    // modifier onlyWhitelisted() {
    // TODO: use this modifier
    //     require(whitelisted[msg.sender], "Not whitelisted");
    //     _;
    // }

    // TODO: add events

    constructor() Ownable(msg.sender) {}

    // TODO:
    // whitelist address with balance DONE
    // update balance for address DONE
    // delete address from whitelisting

    function whitelistAddress(
        address _address,
        address _token,
        Exposure _exposure
    ) external onlyOwner {
        exposure[_address][_token] = _exposure;
    }

    function _charge_address(
        address _address,
        address _token,
        uint256 amount
    ) external onlyOwner {
        Exposure prevExpo = exposure[_address][_token];
        // TODO: add test
        require(
            Exposure.unwrap(prevExpo) >= amount,
            "amount is larger than allowed exposure"
        );
        exposure[_address][_token] = Exposure.wrap(
            Exposure.unwrap(prevExpo) - amount
        );
    }

    // QUOTE operations
    // create quote, restricted to contract owner
    function createQuote(
        address _token,
        uint256 _size,
        uint256 _price
    ) external onlyOwner {
        quotes.push(
            Quote({token: _token, size: _size, price: _price, accepted: false})
        );
    }

    // List quotes
    function listQuotes() public view returns (Quote[] memory) {
        return quotes;
    }
}
