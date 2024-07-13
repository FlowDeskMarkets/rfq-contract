// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/HelloWorld.sol";

contract HelloWorld_test is Test {
    function test_greeting() public {
        HelloWorld helloWorldContract = new HelloWorld();

        assertEq(helloWorldContract.greeting(), "Hello World");
    }
}
