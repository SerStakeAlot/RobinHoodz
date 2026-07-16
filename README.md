# RobinHoodz 🧀

Pixel top-down heist game on Robinhood Chain. Rob the rich, build your AURA,
climb the season leaderboard, claim $FETA at the First Feather Bank.

## Repo contents

| File | Purpose |
|---|---|
| `index.html` | The game (homepage) |
| `whitepaper.html` | Whitepaper — linked from the game's opening screens |
| `FetaClaimBank.sol` | Season payout claim contract (deploy via Remix) |
| `feta-logo-1024.png` / `feta-logo-512.png` | Token / site logo |
| `CNAME` | Custom domain for GitHub Pages (`rhgame.fun`) |

## Live site

- Game: **https://rhgame.fun**
- Whitepaper: **https://rhgame.fun/whitepaper.html**

## Hosting setup (GitHub Pages + rhgame.fun)

1. Push this repo to GitHub (public).
2. Repo **Settings → Pages → Source: Deploy from a branch → main → / (root) → Save**.
3. In **Settings → Pages → Custom domain**, `rhgame.fun` is picked up automatically
   from the `CNAME` file. Tick **Enforce HTTPS** once the certificate is issued
   (can take up to an hour after DNS propagates).

### GoDaddy DNS records

In GoDaddy → My Products → `rhgame.fun` → **DNS**, add:

| Type | Name | Value | TTL |
|---|---|---|---|
| A | `@` | `185.199.108.153` | 1 hour |
| A | `@` | `185.199.109.153` | 1 hour |
| A | `@` | `185.199.110.153` | 1 hour |
| A | `@` | `185.199.111.153` | 1 hour |
| CNAME | `www` | `serstakealot.github.io` | 1 hour |

Delete GoDaddy's default "Parked" A record and any conflicting `@` records.
DNS usually propagates within minutes but can take up to 48 hours.

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
