// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IPokemoonNFT} from "./interfaces/IPokemoonNFT.sol";
import {IPokemoonOracle} from "./interfaces/IPokemoonOracle.sol";

/// @title Pokemoon NFT contract
/// @author Daniel Ceballos
/// @notice An NFT which contains traits based on defined pokemon meme coins
///         Please look into the CONCEPT.md to get more information about it
contract PokemoonNFT is
    IPokemoonNFT,
    ERC721,
    ERC721Enumerable,
    ERC721Burnable,
    Ownable
{
    IPokemoonOracle public immutable oracle;

    uint256 public nextTokenId = 1;
    mapping(uint256 tokenId => IPokemoonOracle.TokenData tokenData) traits;

    /// Constructs the contracts
    /// @param _initialOwner owner that will be set
    /// @param _oracle address of the oracle to receive information from
    /// @dev oracle is permanent
    constructor(
        address _initialOwner,
        address _oracle
    ) ERC721("Pokemoon Memes", "PKMN") Ownable(_initialOwner) {
        oracle = IPokemoonOracle(_oracle);
    }

    /// @inheritdoc IPokemoonNFT
    function mint(address tokenAddress, uint256 chainId) external onlyOwner {
        if (tokenAddress == address(0)) revert("zero address not allowed");

        uint256 tokenId = nextTokenId++;
        IPokemoonOracle.TokenData storage _trait = traits[tokenId];

        _trait.tokenAddress = tokenAddress;
        _trait.chainId = chainId;

        _mint(msg.sender, tokenId);

        emit PokemoonMinted(tokenId, msg.sender, tokenAddress, chainId);
    }

    /// @inheritdoc IPokemoonNFT
    function updateTraits(uint256 tokenId) external onlyOwner {
        if (_ownerOf(tokenId) == address(0)) revert("token does not exist");

        IPokemoonOracle.TokenData storage _trait = traits[tokenId];
        IPokemoonOracle.TokenData memory _traitIncoming = oracle.getTokenData(
            _trait.tokenAddress,
            _trait.chainId
        );

        _trait.name = _traitIncoming.name;
        _trait.symbol = _traitIncoming.symbol;
        _trait.supply = _traitIncoming.supply;
        _trait.holders = _traitIncoming.holders;
        _trait.marketcap = _traitIncoming.marketcap;
        _trait.communityStrength = _traitIncoming.communityStrength;
        _trait.burnToSupplyRatio = _traitIncoming.burnToSupplyRatio;
        _trait.blockNumber = _traitIncoming.blockNumber;
        _trait.blockTimestamp = _traitIncoming.blockTimestamp;

        emit TraitsUpdated(tokenId);
    }

    /// @inheritdoc IPokemoonNFT
    function getTrait(
        uint256 tokenId
    ) external view returns (IPokemoonOracle.TokenData memory _trait) {
        _trait = traits[tokenId];
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
