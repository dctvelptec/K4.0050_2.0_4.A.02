# Pokemoon ERC721 Smart Contract Concept

## Overview

The Pokemoon Trading Card Game is a blockchain-based collectible card system where each card represents a Pokemoon NFT. These NFTs dynamically reflect real-world Pokemon Meme Tokens across multiple blockchains. The contract follows the ERC721 standard and allows minting but prevents burning.

## Key Features

1. **Dynamic Traits**  
Each Pokemoon NFT possesses traits that update based on the real-time status of the corresponding meme token. These traits include:
    - **Name:** Name of the meme token. 
    - **Symbol:** Token symbol (e.g., MOON, PIKA, DOGE).
    - **Address:** The contract address of the meme token.
    - **Network (Chain ID):** Identifies the blockchain where the token exists.
    - **Supply:** Total supply of the meme token.
    - **Holders:** Number of unique wallet addresses holding the token.
    - **Marketcap:** Current market capitalization.
    - **Community Strength (0%-100%):** Measures the community engagement level:
      - **0%:** No community support.
      - **90%:** Community-driven token.
      - **100%:** Fully decentralized DAO.
    - **Burn-to-Supply Ratio:** Percentage of tokens burned relative to total supply.
    - **Block Number:**: statistical data to follow the evolution of the nft
    - **Blocks Timestamp:**: statistical data to follow the evolution of the nft

2. **Minting Mechanism**  
    - Our Start-Up can mint a new Pokemoon NFT by specifying the address and network (chain ID) of the meme token they want to link.
    - The smart contract is fed with real-time data (via an oracle or an off-chain indexer) to assign the dynamic traits.

3. **Non-Burnable NFTs**
    - Once minted, Pokemoon NFTs cannot be burned.
    - This ensures the permanence of each minted NFT in the ecosystem.

4. **Dynamic Trait Updates**
    - Since meme token attributes change over time, the NFT traits must be updatable.
    - The contract will support external calls (via an oracle or API) to refresh token metadata.

5. **Multi-Chain Support**  
    - Each Pokemoon NFT is linked to a specific blockchain based on its chain ID.
    - The system supports multiple networks, enabling cross-chain meme token representation.

## Minting Workflow

1. **Admin Inputs:**
    - Token contract address
    - Chain ID (of the blockchain where the token exists)

2. **Contract Fetches Metadata:**
    - Calls an oracle or an off-chain service to fetch live meme token data.

3. **NFT Minted with Traits:**
    - Stores the metadata within the NFT.
    - Token’s traits can be refreshed to reflect updates.

## Technical Implementations

1. OpenZeppelins Smart Contract Library (https://docs.openzeppelin.com/contracts/5.x/)
2. Foundry Smart Contract Development Toolchain (https://book.getfoundry.sh/)

### Why OpenZeppelin  

OpenZeppelin offers battle proofed smart contracts which are a solid foundation for smart contracts that want to be secure in its underlying processes. It provides the base functionality of our needed ERC721 standard with its available protocol on https://docs.openzeppelin.com/contracts/5.x/erc721. It covers all needs for our task:  
  - (a) state variables to assign digital goods to an owner 
    - a state variable (`_owners`) that contains the assignment of an NFT token id to its owners address: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.2.0/contracts/token/ERC721/ERC721.sol#L28
    - a state variable (`_balances`) that contains the information about the amount of NFTs an address owns: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.2.0/contracts/token/ERC721/ERC721.sol#L30
  - (b) transfer the ownership of digital goods to another owner
    - a function (`transferFrom`) that transfers a given token id from a given address to a given address (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.2.0/contracts/token/ERC721/ERC721.sol#L137)
    - it allows only the owner from the NFT to transfer it (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.2.0/contracts/token/ERC721/ERC721.sol#L144)
    - it updates (`_update`) the balance and apperove the token transfer (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.2.0/contracts/token/ERC721/ERC721.sol#L242)
  - (c) using inheritance structure, because this is the main use-case of OpenZeppelin smart contract libraries. It's made to get (re-)used!

### Why Foundry

Foundry offers a professional toolchain for developing smart contracts. It provides environments for managing dependencies, remappings of installed dependencies and a wide range of testing tools that can be used to highly optimize smart contracts. 

We've compared 3 tools: Hardhat, Truffle and forge. With Truffle being discontinued and Hardhat being a mix of Plugins, JavaScript/TypeScript development workflow, we decided to use Foundry not only because of the key features we already mentioned. It also provide a native test framework based on Solidity. It also seems to be a really good standard for a developing team in terms of team size.

### Economical Reasons

While our Start-Up has to make fast decisions, be efficient and make good economical decisions, we're going to re-use existing, audited and battle-proofed smart contract, in order to focus on our main goal: our TCG.  

We know there is a 3rd-party reliability in the smart contracts we're using from another library. It also adds another attack vector to the ecosystem. This is why we make sure, that we know how the smart contracts work. We've proven that our chosen protocols from OpenZeppelin are sufficient and feasable for our use-cases. In terms of feature-set and security. 

## Future Additions

  - **Metadata Refreshing:** On-chain function that lets users refresh NFT data periodically.
  - **Leaderboard & Rarity Scores:** Rankings based on marketcap, holders, or community strength.
  - **Integration with TCG Gameplay:** Using NFT traits to influence card battles.