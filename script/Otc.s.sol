// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Otc} from "../src/Otc.sol";

contract OtcScript is Script {
    Otc public otcContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        otcContract = new Otc();

        vm.stopBroadcast();
    }
}
