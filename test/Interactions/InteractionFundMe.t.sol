// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {MockV3Aggregator} from "../mocks/MockAgreegatorv3.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionFundMe is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    MockV3Aggregator mockPriceFeed;

    uint256 public constant GAS_PRICE = 1;

    function setUp() external {
        mockPriceFeed = new MockV3Aggregator(8, 2000e8);

        fundMe = new FundMe(address(mockPriceFeed));

        vm.deal(USER, 10 ether);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        
        vm.deal(USER, 5e18);
        vm.prank(USER);
        fundFundMe.fundFundMe(address(fundMe));

        // address funder = fundMe.getFunder(0);
        // assertEq(funder, USER);
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
