// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title  FetaClaimBank — the First Feather Bank's claim window
/// @notice Season payouts for RobinHoods. The owner (game operator) funds this
///         contract with $FETA and awards winners in one transaction, e.g.
///         "pay the top 10 by aura". Players then claim their own payout —
///         in-game, at the First Feather Bank door.
///
/// Season workflow:
///   1. Season ends; compute winners + amounts from the leaderboard.
///   2. Transfer the season's total $FETA from the Reserve wallet to this contract.
///   3. Call award([addr1..addr10], [amt1..amt10], seasonNumber) from the owner wallet.
///      (Amounts are in token base units: 100 FETA = 100 * 10**18.)
///   4. Players press CLAIM at the bank; the contract pays them directly.
///
/// NOTE: if $FETA applies a tax on plain wallet transfers (not just DEX trades),
/// amounts arriving here and leaving to claimers will be net of that tax.
/// Verify with a small test transfer before the first real season.

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract FetaClaimBank {
    address public owner;
    IERC20  public immutable feta;

    /// @notice Unclaimed $FETA per player. Public getter selector: 0x402914f5
    mapping(address => uint256) public claimable;

    /// @notice Total $FETA owed across all players — the contract can never
    ///         be awarded beyond what it actually holds.
    uint256 public totalOwed;

    event Awarded(address indexed player, uint256 amount, uint256 indexed season);
    event Claimed(address indexed player, uint256 amount);
    event Swept(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(address fetaToken) {
        owner = msg.sender;
        feta = IERC20(fetaToken);
    }

    /// @notice Load a season's winners. One call pays the whole leaderboard.
    ///         Selector: 0x3213b0ce
    function award(
        address[] calldata players,
        uint256[] calldata amounts,
        uint256 season
    ) external onlyOwner {
        require(players.length == amounts.length, "length mismatch");
        for (uint256 i = 0; i < players.length; i++) {
            require(players[i] != address(0), "zero address");
            claimable[players[i]] += amounts[i];
            totalOwed += amounts[i];
            emit Awarded(players[i], amounts[i], season);
        }
        // The bank must be solvent for everything it owes.
        require(feta.balanceOf(address(this)) >= totalOwed, "underfunded: send FETA first");
    }

    /// @notice Player withdraws everything owed to them. Selector: 0x4e71d92d
    function claim() external {
        uint256 amount = claimable[msg.sender];
        require(amount > 0, "nothing to claim");
        claimable[msg.sender] = 0;          // zero before transfer: no reentrancy
        totalOwed -= amount;
        require(feta.transfer(msg.sender, amount), "transfer failed");
        emit Claimed(msg.sender, amount);
    }

    /// @notice Reclaim surplus above what players are owed (e.g. dust,
    ///         or unclaimed prizes after a very long time — your policy call).
    function sweep(uint256 amount) external onlyOwner {
        require(
            feta.balanceOf(address(this)) >= totalOwed + amount,
            "would underfund owed claims"
        );
        require(feta.transfer(owner, amount), "transfer failed");
        emit Swept(amount);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "zero address");
        owner = newOwner;
    }
}
