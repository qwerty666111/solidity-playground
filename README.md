# solidity-playground

Learning Solidity one contract at a time. Notes, experiments, gas golf, and onchain puzzles.

## Contracts

| File | What it does |
|------|--------------|
| `SimpleStorage.sol` | Store/retrieve a number — hello world |
| `Counter.sol` | Increment, decrement, reset counter |
| `ERC20Mintable.sol` | Minimal mintable token with owner |
| `Escrow.sol` | Simple 2-party escrow — deposit, approve, release |
| `Timelock.sol` | Queue + execute with delay (mini governance) |

## Why

Learning solidity to build my first dapp on Arc. Writing small contracts every day, testing with Foundry, gradually working up to more complex stuff like AMMs and vaults.

## Run

```bash
forge install
forge test -vvv
```

## Roadmap

- [x] Basic storage & counter
- [x] ERC-20 from scratch
- [x] Escrow
- [ ] Mini AMM (constant product)
- [ ] Staking contract
- [ ] Deploy to Arc testnet

## License

MIT