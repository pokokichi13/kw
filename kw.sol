//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "https://github.com/Brechtpd/base64/blob/main/base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Keyword is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private idCounter;

    //Struct of metadata and hashed value
    //NFT token ID = Array index
    struct dataStruct{
        bytes32 hashedKey;
        string url;
    }
    dataStruct[] dataStructs; 

    //Constructor sets the ID counter.
    constructor() ERC721("KeywordTest", "KW") public {
    }

    //Register NFT and store to dataStruct
    function registerNFT(string memory _key, string memory _url) public returns (uint256){
        dataStruct memory newData = dataStruct(hash(_key), _url);
        dataStructs.push(newData);

        //ID++
        idCounter.increment();
        return idCounter.current()-1;
    }

    //Mint NFT
    function solveMint(uint _id, string memory _key) external {
        //Key needs to be correct
        require(guess(_id, _key));
        require(!_exists(_id));

        //Mint NFT
        _safeMint(msg.sender, _id);

        //string memory uri = tokenURI(_id);
        //Add tokenURI
        _setTokenURI(_id, kaztokenURI(_id));
    }

    function kaztokenURI(uint256 _id) public pure returns (string memory) {
        return string(abi.encodePacked("https://example.com/", Strings.toString(_id), ".json"));
    }

    // Hash keyword and check if it is correct
    function hash(string memory _key) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_key));
    }
    function guess(uint _id, string memory _key) public view returns (bool) {
        return keccak256(abi.encodePacked(_key)) == dataStructs[_id].hashedKey;
    }
    function getHash(uint _id) public view returns (bytes32){
        return dataStructs[_id].hashedKey;
    }
}
