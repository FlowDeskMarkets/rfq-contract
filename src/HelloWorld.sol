// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// import {} from "@op"
contract HelloWorld {
    string public greeting = "Hello World";

    enum side {
        Buy,
        Sell
    }

    struct quote {
        int256 size;
        int256 price;
    }

    ERC20[] public tokens;
}
