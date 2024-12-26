// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {HackathonEscrow} from "src/HackathonEscrow.sol";

contract HackathonEscrowTest is Test {
    HackathonEscrow escrow;

    address organizer = makeAddr("organizer");

    function setUp() public {
        escrow = new HackathonEscrow(organizer);
    }
}
