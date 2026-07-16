# RobinHoodz 🧀

Pixel top-down heist game on Robinhood Chain. Rob the rich, build your AURA,
climb the season leaderboard, claim $FETA at the First Feather Bank.

## Repo contents

| File | Purpose |
|---|---|
| `index.html` | The game (rename `robinhoodz-prototype.html` to this) |
| `whitepaper.html` | Whitepaper — linked from the game's opening screens |
| `FetaClaimBank.sol` | Season payout claim contract (deploy via Remix) |
| `feta-logo-1024.png` / `feta-logo-512.png` | Token / site logo |

## Deploy on GitHub Pages (free hosting)

1. Create a new **public** repo (e.g. `robinhoodz`).
2. Upload these files. **Rename `robinhoodz-prototype.html` → `index.html`**
   (GitHub Pages serves `index.html` as the homepage; the whitepaper's
   "back to the streets" link already points to it).
3. Repo **Settings → Pages → Source: Deploy from a branch → main → / (root) → Save**.
4. Your game is live at `https://<username>.github.io/robinhoodz/` within a minute
   or two. The whitepaper is at `.../whitepaper.html`.

Hosting on a real domain (instead of `file://`) is also what makes
**MetaMask wallet connect work** — wallets don't inject into local files.

## Wiring the token (after launch)

Open `index.html` and fill in the marked config block near the top of the script:

```js
CHAIN_CONFIG.rpcUrls  // official Robinhood Chain RPC
FETA_TOKEN_ADDRESS    // from your Flap launch
RESERVE_ADDRESS       // your Feather-Ral Reserve wallet
CLAIM_BANK_ADDRESS    // from your Remix deploy of FetaClaimBank.sol
```

## Season payout workflow

1. Season ends — read winners from the leaderboard.
2. Swap Reserve WETH → $FETA on the pool (the weekly buyback).
3. Transfer the pool total to the ClaimBank contract.
4. Call `award([addresses], [amounts], seasonNumber)` from the owner wallet
   (block explorer → Write Contract). Amounts are in base units: `100 FETA = 100 * 10^18`.
5. Players claim in-game at the First Feather Bank (`[C]` at the door / 💰 on mobile).

## Controls

WASD / arrows to move · hold **E** to rob · **B** shop · **G** gang HQ ·
**L** leaderboard · **C** claim (at the bank) · touch controls appear on mobile.
