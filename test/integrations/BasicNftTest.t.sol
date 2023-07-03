// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeicdlctvdhgvhnu5xqjm6tvjzaw3oyllq77deguvllb52hzu3ur76m/";

    function setUp() public {
        DeployBasicNft deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public {
        string memory expectedName = "BasicNft";
        string memory actualName = basicNft.name();
        assertEq(
            keccak256(abi.encodePacked(expectedName)),
            keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        assertEq(basicNft.balanceOf(USER), 1);
        assertEq(
            keccak256(abi.encodePacked(PUG)),
            keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }
}
