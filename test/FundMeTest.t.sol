// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {MockV3Aggregator} from "../test/mocks/MockAgreegatorv3.sol";

contract FundmeTest is Test {
    address USER = makeAddr("user");
    MockV3Aggregator mockPriceFeed;
    FundMe fundMe;
    receive() external payable {}

    function setUp() external {
        mockPriceFeed = new MockV3Aggregator(8, 2000e8);

        fundMe = new FundMe(address(mockPriceFeed));

        vm.deal(USER, 10 ether);
    }

    function testMinDollarFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerisMsgSender() public {
        assertEq(fundMe.getOwner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundDataStructuresWork() public {
        vm.prank(USER);
        fundMe.fund{value: 10e18}();

        uint256 ammountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(ammountFunded, 10e18);
    }
    function testFunderAddedToArray() public funded{
      

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }
    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value: 10e18}();
        _;
    }

    function testIfOnlyOwnerCanWithdraw() public funded{
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }
    function testWithdrawWithASingleFunder() public funded{
       
      uint256 startingOwnerBalance = fundMe.getOwner().balance;
      uint256 startingFundMeBalance = address(fundMe).balance;

      vm.prank(fundMe.getOwner());
      fundMe.withdraw();

      uint256 endingOwnerBalance = fundMe.getOwner().balance;
      uint256 endingFundMeBalance = address(fundMe).balance;
      assertEq(endingFundMeBalance, 0);
      assertEq( startingFundMeBalance + startingOwnerBalance,
          endingOwnerBalance
      );
    }
}
