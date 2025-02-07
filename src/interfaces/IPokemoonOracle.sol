// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Interface of the Pokemoon Oracle
/// @author Daniel Ceballos
interface IPokemoonOracle {
    /// @dev data structure
    struct UpdateTokenDataParams {
        string name;
        string symbol;
        uint256 supply;
        uint256 holders;
        uint256 marketcap;
        uint8 communityStrength;
        uint256 burnToSupplyRatio;
    }

    /// @dev data structure
    struct TokenData {
        address tokenAddress;
        uint256 chainId;
        string name;
        string symbol;
        uint256 supply;
        uint256 holders;
        uint256 marketcap;
        uint8 communityStrength;
        uint256 burnToSupplyRatio;
        // statistical data
        uint256 blockNumber;
        uint256 blockTimestamp;
    }

    /// Event thats been emitted after token data has been updated
    /// @param round the current round the data has been set for
    /// @param pointer pointer to the array index of the data
    /// @param data the data itself
    event UpdatedTokenData(uint256 round, uint256 pointer, TokenData data);

    /// Returns the token data based on a given token address and chain id
    /// @param tokenAddress address of the token
    /// @param chainId chain id
    function getTokenData(
        address tokenAddress,
        uint256 chainId
    ) external view returns (TokenData memory _tokenData);

    /// Returns the token data based on a given token address, chain id and round
    /// @param tokenAddress address of the token
    /// @param chainId chain id
    /// @param round number
    function getTokenData(
        address tokenAddress,
        uint256 chainId,
        uint256 round
    ) external view returns (TokenData memory _tokenData);

    /// Updates the oracles token data
    /// @param tokenAddress address ot the token
    /// @param chainId chain id
    /// @param _params update parameter that should be set for the token
    /// @dev only the owner is allowed to do this
    function updateTokenData(
        address tokenAddress,
        uint256 chainId,
        UpdateTokenDataParams calldata _params
    ) external;
}
