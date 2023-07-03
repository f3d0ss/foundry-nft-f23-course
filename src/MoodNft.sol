// Type declarations
// State variables
// Events
// Errors
// Modifiers
// Functions

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    enum Mood {
        HAPPY,
        SAD
    }

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    mapping(uint256 => Mood) s_tokenIdToMood;

    // errors
    error MoodNft__CanFlipMoodIfNotOwner();

    constructor(
        string memory happySvgImageUri,
        string memory sadSvgImageUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // only owner
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CanFlipMoodIfNotOwner();
        }
 
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }
        string memory json = string.concat(
            '{"name": "',
            name(),
            '", "description": "An NFT that reflects user mood.", "attributes": ["trait_type": "moodiness", "value": 100], "image": "',
            imageURI,
            '"}'
        );

        string memory jsonBase64 = Base64.encode(bytes(json));

        return string.concat(_baseURI(), jsonBase64);
    }
}
