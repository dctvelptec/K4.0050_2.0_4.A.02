// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPokemoonOracle} from "./IPokemoonOracle.sol";

/// @title Interface for PokemoonNFT
/// @author Daniel Ceballos
/// @notice outlines the functionality of the PokemoonNFT
interface IPokemoonNFT {
    /// Minting event of the nft
    /// @param tokenId id of the created token
    /// @param owner owner of the token
    /// @param tokenAddress address of the corresponding meme
    /// @param chainId chain id
    event PokemoonMinted(
        uint256 indexed tokenId,
        address indexed owner,
        address tokenAddress,
        uint256 chainId
    );

    /// Trait update event
    /// @param tokenId id of the token
    event TraitsUpdated(uint256 indexed tokenId);

    /// Mints an NFT based on a token address and desired chain id
    /// @param tokenAddress address of the meme coin
    /// @param chainId chain id
    function mint(address tokenAddress, uint256 chainId) external;

    /// Updates the traits of the token
    /// @param tokenId id of the token
    /// @dev can only be executed by owner
    function updateTraits(uint256 tokenId) external;

    /// Returns the current trait information of the nft
    /// @param tokenId id of the token
    function getTrait(
        uint256 tokenId
    ) external view returns (IPokemoonOracle.TokenData memory _trait);
}
