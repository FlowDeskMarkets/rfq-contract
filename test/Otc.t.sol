// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Otc.sol";

contract OtcTest is Test {
    function test_whitelistAddress() public {
        Otc helloWorldContract = new Otc();
        address wallet_addr = address(0x123);
        Exposure exposureValue = Exposure.wrap(1000);

        helloWorldContract.whitelistAddress(wallet_addr, exposureValue);

        Exposure storedExposure = helloWorldContract.exposure(wallet_addr);

        assertEq(
            Exposure.unwrap(storedExposure),
            Exposure.unwrap(exposureValue)
        );
    }

    function testNonOwnerCannotWhitelist() public {
        Otc helloWorldContract = new Otc();

        Exposure exposureValue = Exposure.wrap(1000);
        address wallet_addr = address(0x123);

        vm.prank(wallet_addr);
        vm.expectRevert();
        helloWorldContract.whitelistAddress(wallet_addr, exposureValue);
    }

    // ---------------------- createQuote ----------------------
    function testCreateQuote() public {
        Otc otcContract = new Otc();

        address tokenAddr = address(0x123);
        uint256 quotePrice = 1000;
        uint256 quoteSize = 42;
        uint256 quoteId = otcContract.postQuote(
            tokenAddr,
            Otc.QuoteSide.Buy,
            quoteSize,
            quotePrice
        );
        (
            address token,
            Otc.QuoteSide side,
            uint256 amount,
            uint256 price,
            bool accepted
        ) = otcContract.quotes(0);

        assertEq(token, tokenAddr);
        assertEq(amount, 42);
        assertEq(uint8(side), uint8(Otc.QuoteSide.Buy));
        assertEq(price, 1000);
        assertEq(accepted, false);
        assertEq(quoteId, 1);
    }

    function testNonOwnerCannotPostQuote() public {
        address tokenAddr = address(0x123);
        address addr2 = address(0x456);
        Otc otcContract = new Otc();

        vm.prank(addr2);
        vm.expectRevert();
        otcContract.postQuote(tokenAddr, Otc.QuoteSide.Buy, 100, 50);
    }

    // ---------------------- listQuotes ----------------------
    function testListQuotes() public {
        Otc otcContract = new Otc();

        address tokenAddr = address(0x123);
        address sender = address(0x456);
        otcContract.whitelistAddress(sender, Exposure.wrap(1000));

        otcContract.postQuote(tokenAddr, Otc.QuoteSide.Sell, 100, 50);

        vm.prank(sender);
        // WHEN
        Otc.Quote[] memory quotes = otcContract.listQuotes();

        assertEq(quotes[0].token, tokenAddr);
        assertEq(uint8(quotes[0].side), uint8(Otc.QuoteSide.Sell));
        assertEq(quotes[0].size, 100);
        assertEq(quotes[0].price, 50);
        assertEq(quotes[0].accepted, false);
    }

    function testListQuotesForNoneWhitelistedUsers() public {
        Otc otcContract = new Otc();

        address tokenAddr = address(0x123);

        otcContract.postQuote(tokenAddr, Otc.QuoteSide.Sell, 100, 50);

        vm.expectRevert("Not whitelisted or collateral is 0");
        otcContract.listQuotes();
    }

    // ---------------------- acceptQuote ----------------------
    function testAcceptQuote() public {
        address owner = address(this);
        vm.prank(owner);
        Otc otcContract = new Otc();

        address clientAddr = address(0x123);
        address tokenAddr = address(0x456);

        // Whitelist the user
        otcContract.whitelistAddress(clientAddr, Exposure.wrap(10_000));

        vm.prank(owner);
        // Post a quote
        otcContract.postQuote(tokenAddr, Otc.QuoteSide.Buy, 100, 50);

        // Set the sender again
        vm.prank(clientAddr);

        // Accept the quote
        otcContract.acceptQuote(0);

        // Retrieve the updated quote
        (, , , , bool accepted) = otcContract.quotes(0);
        assertEq(accepted, true);
        assertEq(Exposure.unwrap(otcContract.exposure(clientAddr)), 9900);
    }
}
