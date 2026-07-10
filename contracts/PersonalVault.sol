// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract PersonalVault {

    // ==========================================================
    // State Variables
    // ==========================================================

    // Pemilik vault
    address public owner;

    // Waktu ketika dana sudah boleh diambil
    uint256 public unlockTime;

    // ==========================================================
    // Events
    // ==========================================================

    // Dipanggil ketika ada ETH yang masuk
    event Deposit(address indexed sender, uint256 amount);

    // Dipanggil ketika owner berhasil menarik dana
    event Withdrawal(uint256 amount, uint256 timestamp);

    // Dipanggil ketika waktu lock diperpanjang
    event LockExtended(uint256 newUnlockTime);

    // ==========================================================
    // Custom Errors
    // ==========================================================

    error FundsLocked();
    error NotOwner();
    error InvalidUnlockTime();
    error NoFunds();
    error TransferFailed();

    // ==========================================================
    // Modifier
    // ==========================================================

    /**
     * @dev Hanya owner yang boleh menjalankan fungsi tertentu.
     */
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    // ==========================================================
    // Constructor
    // ==========================================================

    /**
     * @param _unlockTime Waktu unlock dalam format Unix Timestamp.
     */
    constructor(uint256 _unlockTime) payable {

        // Unlock time harus lebih besar dari waktu sekarang
        if (_unlockTime <= block.timestamp) {
            revert InvalidUnlockTime();
        }

        owner = msg.sender;
        unlockTime = _unlockTime;

        // Jika deploy sambil mengirim ETH
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    // ==========================================================
    // Deposit Function
    // ==========================================================

    /**
     * @notice Menambahkan ETH ke dalam vault.
     */
    function deposit() external payable onlyOwner {

        require(msg.value > 0, "Must send ETH");

        emit Deposit(msg.sender, msg.value);
    }

    // ==========================================================
    // Withdraw Function
    // ==========================================================

    /**
     * @notice Mengambil seluruh saldo vault.
     * Cuma bisa dilakukan setelah unlock time.
     */
    function withdraw() external onlyOwner {

        // Cek apakah waktu lock sudah selesai
        if (block.timestamp < unlockTime) {
            revert FundsLocked();
        }

        uint256 amount = address(this).balance;

        // Tidak ada saldo
        if (amount == 0) {
            revert NoFunds();
        }

        // Transfer ETH menggunakan call()
        (bool success, ) = payable(owner).call{value: amount}("");

        if (!success) {
            revert TransferFailed();
        }

        emit Withdrawal(amount, block.timestamp);
    }

    // ==========================================================
    // Extend Lock
    // ==========================================================

    /**
     * @notice Memperpanjang waktu lock.
     * Waktu lock tidak boleh dipersingkat.
     */
    function extendLock(uint256 newTime)
        external
        onlyOwner
    {
        if (newTime <= unlockTime) {
            revert InvalidUnlockTime();
        }

        unlockTime = newTime;

        emit LockExtended(newTime);
    }

    // ==========================================================
    // View Functions
    // ==========================================================

    /**
     * @return Saldo ETH yang ada di dalam contract.
     */
    function getBalance()
        external
        view
        returns (uint256)
    {
        return address(this).balance;
    }

    /**
     * @return True jika vault sudah bisa diwithdraw.
     */
    function isUnlocked()
        external
        view
        returns (bool)
    {
        return block.timestamp >= unlockTime;
    }

    // ==========================================================
    // Receive Function
    // ==========================================================

    /**
     * @notice Menerima ETH langsung ke contract.
     */
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}