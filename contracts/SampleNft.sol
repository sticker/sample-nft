// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

contract SampleNft is ERC721EnumerableUpgradeable, AccessControlUpgradeable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    string public baseURI;
    uint256 private _currentTokenId;
    mapping(address => bool) private _blockedAddresses;

    function initialize(string calldata __baseURI) public initializer {
        __ERC721_init("Sample NFT", "SAMPLE");
        __AccessControl_init();

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(BURNER_ROLE, _msgSender());

        baseURI = __baseURI;
        _currentTokenId = 0;
    }

    function addBlockedAddress(
        address blockedAddress
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _blockedAddresses[blockedAddress] = true;
    }

    function removeBlockedAddress(
        address blockedAddress
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _blockedAddresses[blockedAddress] = false;
    }

    function isBlockedAddress(
        address queryAddress
    ) external view returns (bool) {
        return _blockedAddresses[queryAddress];
    }

    function mint(address to) public onlyRole(MINTER_ROLE) returns (uint256) {
        _currentTokenId += 1;
        _mint(to, _currentTokenId);
        return _currentTokenId;
    }

    function getTokenIds(address owner) public view returns (uint256[] memory) {
        uint256[] memory ids = new uint256[](balanceOf(owner));
        for (uint256 i = 0; i < ids.length; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            ids[i] = tokenId;
        }
        return ids;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(
        string calldata __baseURI
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        baseURI = __baseURI;
    }

    function currentTokenId() public view returns (uint256) {
        return _currentTokenId;
    }

    function setCurrentTokenId() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _currentTokenId = totalSupply();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721EnumerableUpgradeable) {
        require(
            !_blockedAddresses[from] && !_blockedAddresses[to],
            "Transfer blocked addresses is not allowed"
        );
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function burn(uint256 tokenId) public onlyRole(BURNER_ROLE) {
        _burn(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721Upgradeable) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721Upgradeable) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721EnumerableUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
