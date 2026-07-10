# Time Locked Personal Vault

Smart contract Solidity yang memungkinkan pengguna mengunci ETH hingga waktu tertentu.

## Features

- Deposit ETH
- Withdraw setelah unlock
- Extend lock
- Owner only
- Custom Errors
- Event Logging

## Tech Stack

- Solidity
- Hardhat 3
- TypeScript
- Ethers.js

## Deploy

```bash
npx hardhat run scripts/deploy.ts --network sepolia
```

## Compile

```bash
npx hardhat compile
```

## Test

```bash
npx hardhat test
```
## Testing Checklist

- [✔] Deploy dengan `unlockTime` = 5 menit dari sekarang
- [✔] Deposit 1 ETH → sukses, emit `Deposit` event
- [✔] Coba withdraw sebelum waktunya → revert `FundsLocked()`
- [✔] `extendLock` ke waktu lebih lama → sukses
- [✔] Coba `extendLock` ke waktu lebih pendek → gagal
- [?] Majukan waktu, withdraw sebagai owner → sukses, terima semua ETH
- [✔] Coba withdraw lagi → gagal (saldo kosong)

## Deployment Info

- **Nama & NIM: HAPIZD NURYADIN (241011402448)**
- **Contract Address (Sepolia): 0x81cBdE3F823b9248BBF63E5eBf7597BAA5d11Bc3** 
- **Etherscan Verified Link:https://sepolia.etherscan.io/address/0x81cbde3f823b9248bbf63e5ebf7597baa5d11bc3#readContract**
- **Unlock Time (deploy awal):1783680132**
- **Tx Hash — Deposit:0xfd0fedf5fbecb5c3d69a0835735d4d9f024f408d804e4c6b26230f070bb6c03e**
- **Tx Hash — Failed Withdrawal (sebelum unlock):0xe9a255da140ec4981aaeba40366ed5ef0fb8efc618224db44dd9317fcf8d1716**
- **Tx Hash — Successful Withdrawal (setelah unlock):0x6248f5e4a67c0b19ac958aa372ef7743cc48dad7061ffa6079dbc6f3c450d13a**