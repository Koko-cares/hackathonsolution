// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {HackathonFactory} from "src/HackathonFactory.sol";

contract HackathonFactoryTest is Test {
    HackathonFactory factory;

    function setUp() public {
        factory = new HackathonFactory();
    }
}
