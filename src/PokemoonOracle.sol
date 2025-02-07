// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AccessControlEnumerable} from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";
import {EnumerableMap} from "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import {IPokemoonOracle} from "./interfaces/IPokemoonOracle.sol";

/// @title Pokemoon Oracle
/// @author Daniel Ceballos
/// @notice This oracle stores all data for tokens that are part of the pokemoon nft
///         This is a management contract. No need to add access risks to the major NFT contract
contract PokemoonOracle is IPokemoonOracle, AccessControlEnumerable {
    /// @notice alias for the enum map uint to uint
    using EnumerableMap for EnumerableMap.UintToUintMap;

    /// @notice default role for a third party that can update the oracles on chain data
    bytes32 public constant ROLE_ORACLE = keccak256("ROLE_ORACLE");

    /// @dev contains tokenData pointers
    mapping(uint256 chainId => mapping(address tokenAddress => EnumerableMap.UintToUintMap rounds)) pointers;

    /// @dev contains all token data in one array
    /// @dev updates get pushed on top to keep historical data in place
    /// @dev for statistical and development reasons (uuuuh, that NFT got huuuuuuge, you know)
    TokenData[] tokenData;

    /// @dev we're granting roles to give access to a third party that is goinf to update the traits later on
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ROLE_ORACLE, msg.sender);
        _setRoleAdmin(ROLE_ORACLE, DEFAULT_ADMIN_ROLE);

        // skip first entry to avoidn initial uint256 correlation
        tokenData.push();
    }

    /// @inheritdoc IPokemoonOracle
    function getTokenData(address tokenAddress, uint256 chainId, uint256 round)
        external
        view
        returns (TokenData memory _tokenData)
    {
        uint256 pointer = pointers[chainId][tokenAddress].get(round);
        if (pointer > 0) _tokenData = tokenData[pointer];
    }

    /// @inheritdoc IPokemoonOracle
    function getTokenData(address tokenAddress, uint256 chainId) external view returns (TokenData memory _tokenData) {
        uint256 pointer = pointers[chainId][tokenAddress].get(pointers[chainId][tokenAddress].length() - 1);
        if (pointer > 0) _tokenData = tokenData[pointer];
    }

    /// @inheritdoc IPokemoonOracle
    function updateTokenData(address tokenAddress, uint256 chainId, UpdateTokenDataParams calldata _params)
        external
        onlyRole(ROLE_ORACLE)
    {
        uint256 nextRound = pointers[chainId][tokenAddress].length();
        uint256 nextPointer = tokenData.length;

        tokenData.push(
            TokenData({
                tokenAddress: tokenAddress,
                chainId: chainId,
                name: _params.name,
                symbol: _params.symbol,
                supply: _params.supply,
                holders: _params.holders,
                marketcap: _params.marketcap,
                communityStrength: _params.communityStrength,
                burnToSupplyRatio: _params.burnToSupplyRatio,
                blockNumber: block.number,
                blockTimestamp: block.timestamp
            })
        );

        pointers[chainId][tokenAddress].set(nextRound, nextPointer);

        emit UpdatedTokenData(nextRound, nextPointer, tokenData[nextPointer]);
    }
}
