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

    /// Update or create exposure for a given address (whitelist address)
    /// @param _address address to whitelist
    /// @param _token token
    /// @param _exposure exposure value
    function whitelistAddress(
        address _address,
        address _token,
        Exposure _exposure
    ) external onlyOwner {
        exposure[_address][_token] = _exposure;
    }

    /// Charge an address a certain amount of tokens (decrease exposure)
    /// @param _address address to whitelist
    /// @param _token token
    /// @param _amount size to remove from exposure
    function _charge_address(
        address _address,
        address _token,
        uint256 _amount
    ) external onlyOwner {
        Exposure prevExpo = exposure[_address][_token];
        // TODO: add test
        require(
            Exposure.unwrap(prevExpo) >= _amount,
            "amount is larger than allowed exposure"
        );
        exposure[_address][_token] = Exposure.wrap(
            Exposure.unwrap(prevExpo) - _amount
        );
    }

    /////////////////////////////////////// QUOTE operations

    /// create quote, restricted to contract owner
    /// @param _token token address
    /// @param _size quote size
    /// @param _price quote price
    function postQuote(
        address _token,
        uint256 _size,
        uint256 _price
    ) external onlyOwner returns (uint256) {
        quotes.push(
            Quote({token: _token, size: _size, price: _price, accepted: false})
        );
        return quotes.length;
    }

    /// Retrieve a list of available quotes
    function listQuotes() public view returns (Quote[] memory) {
        // TODO: filter expired
        return quotes;
    }

    // function acceptQuote(uint256 _quoteId) external payable {
    //     Quote storage quote = quotes[_quoteId];
    //     require(!quote.accepted, "Quote already accepted");
    //     require(
    //         msg.value == quote.amount * quote.price,
    //         "Incorrect ETH amount"
    //     );
    //
    //     quote.accepted = true;
    //
    //     // Transfer tokens from seller to buyer
    //     IERC20(quote.token).transferFrom(
    //         quote.seller,
    //         msg.sender,
    //         quote.amount
    //     );
    //     // Transfer ETH from contract to seller
    //     payable(quote.seller).transfer(msg.value);
    // }
}
