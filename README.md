## Flowdesk RFQ Defi

Defi RFQ smart contract for institutional firms, it gives the ability to do programmatic OTC trades.

<img src="https://img.shields.io/badge/Solidity-e6e6e6?style=for-the-badge&logo=solidity&logoColor=black" />

## Features

- Whitelisting an Address: The contract owner can whitelist an address by setting its exposure.
- Posting a Quote: The contract owner can post buy/sell quotes for supported ERC20 tokens.
- Viewing Quotes: Whitelisted users with positive collateral can view available quotes.
- Accepting a Quote: Whitelisted users with positive collateral can accept quotes, which will update their exposure and mint a corresponding position.

This contract ensures secure and efficient OTC trading while maintaining strict access control and collateral management.

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Deploy

```shell
$ forge script script/Otc.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Test transactions

`https://rpc.sepolia.org`
`https://rpc-amoy.polygon.technology`

```
export PRIVATE_KEY="private_key"
export CONTRACT_ADDRESS="private_key"
export RPC_URL="rpc_url"
```

### Create quote

```
cast send \
--private-key $PRIVATE_KEY \
--rpc-url $RPC_URL  \
$CONTRACT_ADDRESS "postQuote(address token, uint8 side, uint256 size, uint256 price)" \
0xD0684a311F47AD7fdFf03951d7b91996Be9326E1 0 1 50000000
```

### Whitelist address

```
export CLIENT_ADDRESS="client_address"

cast send \
--private-key $PRIVATE_KEY \
--rpc-url $RPC_URL  \
$CONTRACT_ADDRESS "whitelistAddress(address address, uint256 exposure)" \
$CLIENT_ADDRESS 10000

```

### List quotes

```
cast call \
--private-key $PRIVATE_KEY \
--rpc-url $RPC_URL  \
$CONTRACT_ADDRESS "listQuotes()" \
```

### Accept quote

```
cast send \
--private-key $PRIVATE_KEY \
--rpc-url $RPC_URL  \
$CONTRACT_ADDRESS "acceptQuote(uint256 quoteId)" \
0
```
