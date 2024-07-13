// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {HelloWorld} from "../src/HelloWorld.sol";

contract HelloWorldScript is Script {
    HelloWorld public helloWorld;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        helloWorld = new HelloWorld();

        vm.stopBroadcast();
    }
}