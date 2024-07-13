## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Test transactions

```
export PRIVATE_KEY="private_key"
export CONTRACT_ADDRESS="private_key"
```

### Create quote

```
cast send \
--private-key $PRIVATE_KEY \
--rpc-url https://rpc.sepolia.org  \
$CONTRACT_ADDRESS "postQuote(address token, uint8 side, uint256 size, uint256 price)" \
0xD0684a311F47AD7fdFf03951d7b91996Be9326E1 0 1 50000000
```

### Whitelist address

```
cast send \
--private-key $PRIVATE_KEY \
--rpc-url https://rpc.sepolia.org  \
$CONTRACT_ADDRESS "whitelistAddress(address address, uint256 exposure)" \
0xe3474c5Ccf3E882b442f2B46c43F1ae3c17F3887 10000

```

### List quotes

```
cast call \
--private-key $PRIVATE_KEY \
--rpc-url https://rpc.sepolia.org  \
$CONTRACT_ADDRESS "listQuotes()" \
```

### Accept quote

```
cast send \
--private-key $PRIVATE_KEY \
--rpc-url https://rpc.sepolia.org  \
$CONTRACT_ADDRESS "acceptQuote(uint256 quoteId)" \
0
```
