// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Otc.sol";

contract HelloWorld_test is Test {
    function test_whitelistAddress() public {
        Otc helloWorldContract = new Otc();
        address wallet_addr = address(0x123);
        address token_addr = address(0x456);
        Exposure exposureValue = Exposure.wrap(1000);

        helloWorldContract.whitelistAddress(
            wallet_addr,
            token_addr,
            exposureValue
        );

        Exposure storedExposure = helloWorldContract.exposure(
            wallet_addr,
            token_addr
        );

        assertEq(
            Exposure.unwrap(storedExposure),
            Exposure.unwrap(exposureValue)
        );
    }

    function testNonOwnerCannotWhitelist() public {
        Otc helloWorldContract = new Otc();

        Exposure exposureValue = Exposure.wrap(1000);
        address wallet_addr = address(0x123);
        address token_addr = address(0x456);

        vm.prank(wallet_addr);
        vm.expectRevert();
        helloWorldContract.whitelistAddress(
            wallet_addr,
            token_addr,
            exposureValue
        );
    }

    // ---------------------- createQuote ----------------------
    function testCreateQuote() public {
        Otc otcContract = new Otc();

        address tokenAddr = address(0x123);
        uint256 quotePrice = 1000;
        uint256 quoteSize = 42;
        otcContract.createQuote(tokenAddr, quoteSize, quotePrice);
        (
            address token,
            uint256 amount,
            uint256 price,
            bool accepted
        ) = otcContract.quotes(0);

        assertEq(token, tokenAddr);
        assertEq(amount, 42);
        assertEq(price, 1000);
        assertEq(accepted, false);
    }

    function testNonOwnerCannotPostQuote() public {
        address tokenAddr = address(0x123);
        address addr2 = address(0x456);
        Otc otcContract = new Otc();

        vm.prank(addr2);
        vm.expectRevert();
        otcContract.createQuote(tokenAddr, 100, 50);
    }

    // ---------------------- listQuotes ----------------------
    function testListQuotes() public {
        Otc otcContract = new Otc();

        address tokenAddr = address(0x123);
        otcContract.createQuote(tokenAddr, 100, 50);
        Otc.Quote[] memory quotes = otcContract.listQuotes();

        assertEq(quotes[0].token, tokenAddr);
        assertEq(quotes[0].size, 100);
        assertEq(quotes[0].price, 50);
        assertEq(quotes[0].accepted, false);
    }
}
