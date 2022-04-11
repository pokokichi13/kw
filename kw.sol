//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "https://github.com/Brechtpd/base64/blob/main/base64.sol";

contract Keyword is ERC721 {
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
    function registerNFT(string memory _key, string memory _url) public {
        dataStruct memory newData = dataStruct(hash(_key), _url);
        dataStructs.push(newData);
        idCounter.increment();
    }

    //Mint NFT
    function solveMint(uint _id, string memory _key) external {
        //Key needs to be correct
        require(guess(_id, _key));
        require(!_exists(_id));

        //Mint NFT
        _safeMint(msg.sender, _id);
    
        //TBD
        //Shape tokenURI
        //Add tokenURI
        //_setTokenURI(_id, );
    }

    function tokenURI(uint256 _tokenId) override public view returns (string memory) {
        string memory image = dataStructs[_tokenId].url;
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "MY NFT", "description": "", "image_data": "', image, '"}'))));
        return string(abi.encodePacked('data:application/json;base64,', json));
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
