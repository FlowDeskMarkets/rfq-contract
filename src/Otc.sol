// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./FlowOtc.sol";

type Exposure is uint256;
type Price is uint256;

contract Otc is Ownable, FlowOtc {
    enum QuoteSide {
        Buy,
        Sell
    }

    struct Quote {
        address token;
        QuoteSide side;
        uint256 size;
        uint256 price;
        bool accepted;
        // TODO: add expiration
    }

    ERC721 private nftContract;

    ERC20[] public tokens;
    Quote[] public quotes;

    // wallet => token => balance // IN USD_Stable
    mapping(address => Exposure) public exposure;

    modifier onlyWhitelistedWithPositiveCollateral() {
        require(
            Exposure.unwrap(exposure[msg.sender]) > 0,
            "Not whitelisted or collateral is 0"
        );
        _;
    }

    // TODO: add events

    constructor() Ownable(msg.sender) {}

    /// Update or create exposure for a given address (whitelist address)
    /// @param _address address to whitelist
    /// @param _exposure exposure value
    function whitelistAddress(
        address _address,
        Exposure _exposure
    ) external onlyOwner {
        exposure[_address] = _exposure;
    }

    /// Charge an address a certain amount of tokens (decrease exposure)
    /// @param _address address to whitelist
    /// @param _amount size to remove from exposure
    function _charge_address(address _address, uint256 _amount) internal {
        Exposure prevExpo = exposure[_address];
        // TODO: add test
        require(
            Exposure.unwrap(prevExpo) >= _amount,
            "amount is larger than allowed exposure"
        );
        exposure[_address] = Exposure.wrap(Exposure.unwrap(prevExpo) - _amount);
    }

    /////////////////////////////////////// QUOTE operations

    /// create quote, restricted to contract owner
    /// @param _token token address
    /// @param _size quote size
    /// @param _price quote price
    function postQuote(
        address _token,
        QuoteSide _side,
        uint256 _size,
        uint256 _price
    ) external onlyOwner returns (uint256) {
        quotes.push(
            Quote({
                token: _token,
                side: _side,
                size: _size,
                price: _price,
                accepted: false
            })
        );
        return quotes.length;
    }

    /// Retrieve a list of available quotes
    function listQuotes()
        public
        view
        onlyWhitelistedWithPositiveCollateral
        returns (Quote[] memory)
    {
        // TODO: filter expired
        return quotes;
    }

    function acceptQuote(
        uint256 _quoteId
    ) external onlyWhitelistedWithPositiveCollateral {
        Quote storage quote = quotes[_quoteId];
        require(!quote.accepted, "Quote already accepted");

        quote.accepted = true;
        // MINT position
        safeMint(msg.sender);

        _charge_address(msg.sender, quote.size);
    }
}
