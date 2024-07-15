// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FlowOtc is ERC721 {
    uint256 private nextQuoteClaimId;

    constructor() ERC721("FlowOtc", "OTC") {
        nextQuoteClaimId = 1;
    }

    function safeMint(address to) internal {
        uint256 tokenId = nextQuoteClaimId;
        nextQuoteClaimId++;

        _safeMint(to, tokenId);
    }
}
