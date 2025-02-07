// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console, Vm as vm} from "forge-std/Test.sol";
import {PokemoonOracle} from "../src/PokemoonOracle.sol";
import {IPokemoonOracle} from "../src/interfaces/IPokemoonOracle.sol";

contract PokemoonOracleTest is Test {
    PokemoonOracle public oracle;

    function setUp() public {
        oracle = new PokemoonOracle();
    }

    function test_RevertWhenInvalidTokenAddressAndRound() public {
        vm.expectRevert();
        oracle.getTokenData(address(0), 0, 0);
    }

    function test_RevertWhenInvalidTokenAddress() public {
        vm.expectRevert();
        oracle.getTokenData(address(0), 0);
    }

    function test_UpdateTokenDataSuccessfully() public {
        vm.expectEmit(address(oracle));
        emit IPokemoonOracle.UpdatedTokenData(
            0,
            1,
            IPokemoonOracle.TokenData({
                tokenAddress: address(0x1),
                chainId: 1,
                name: "test_name",
                symbol: "test_symbol",
                supply: 1,
                holders: 1,
                marketcap: 1,
                communityStrength: 1,
                burnToSupplyRatio: 1,
                blockNumber: vm.getBlockNumber(),
                blockTimestamp: vm.getBlockTimestamp()
            })
        );
        oracle.updateTokenData(
            address(0x1),
            1,
            IPokemoonOracle.UpdateTokenDataParams({
                name: "test_name",
                symbol: "test_symbol",
                supply: 1,
                holders: 1,
                marketcap: 1,
                communityStrength: 1,
                burnToSupplyRatio: 1
            })
        );
    }

    function test_GetAvailableTokenData() public {
        oracle.updateTokenData(
            address(0x1),
            1,
            IPokemoonOracle.UpdateTokenDataParams({
                name: "test_name",
                symbol: "test_symbol",
                supply: 1,
                holders: 1,
                marketcap: 1,
                communityStrength: 1,
                burnToSupplyRatio: 1
            })
        );
        oracle.updateTokenData(
            address(0x1),
            1,
            IPokemoonOracle.UpdateTokenDataParams({
                name: "test_name",
                symbol: "test_symbol",
                supply: 2,
                holders: 2,
                marketcap: 2,
                communityStrength: 2,
                burnToSupplyRatio: 2
            })
        );

        IPokemoonOracle.TokenData memory _tokenDataFirstRound = oracle.getTokenData(address(0x1), 1, 0);

        IPokemoonOracle.TokenData memory _tokenDataLatest = oracle.getTokenData(address(0x1), 1);

        assertEq(_tokenDataFirstRound.supply, 1);
        assertEq(_tokenDataLatest.supply, 2);
    }
}
