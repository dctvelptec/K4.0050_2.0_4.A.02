// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console, Vm as vm} from "forge-std/Test.sol";
import {PokemoonNFT} from "../src/PokemoonNFT.sol";
import {IPokemoonNFT} from "../src/interfaces/IPokemoonNFT.sol";
import {PokemoonOracle} from "../src/PokemoonOracle.sol";
import {IPokemoonOracle} from "../src/interfaces/IPokemoonOracle.sol";

contract PokemoonNFTTest is Test {
    PokemoonNFT public nft;
    PokemoonOracle public oracle;

    function setUp() public {
        oracle = new PokemoonOracle();
        nft = new PokemoonNFT(address(this), address(oracle));
    }

    function test_CorrectOracleShouldBeSet() public view {
        assertEq(address(oracle), address(nft.oracle()));
    }

    function test_AddNewNFT() public {
        vm.expectEmit(address(nft));
        emit IPokemoonNFT.PokemoonMinted(1, address(this), address(0x1), 1);
        nft.mint(address(0x1), 1);
    }

    function test_UpdateTrait() public {
        // prepare oracle
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

        nft.mint(address(0x1), 1);

        vm.expectEmit(address(nft));
        emit IPokemoonNFT.TraitsUpdated(1);

        nft.updateTraits(1);
    }

    function test_GetUpdatedTrait() public {
        // prepare oracle
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
        nft.mint(address(0x1), 1);
        nft.updateTraits(1);

        IPokemoonOracle.TokenData memory _trait = nft.getTrait(1);

        assertEq(_trait.tokenAddress, address(0x1));
        assertEq(_trait.name, "test_name");
        assertEq(_trait.supply, 1);
    }
}
