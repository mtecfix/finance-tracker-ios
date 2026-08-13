# Finance Tracker iOS
> Personal finance app built for irregular income earners — freelancers, gig workers, contractors, and RSU recipients.

[![Build](https://github.com/mtecfix/finance-tracker-ios/actions/workflows/build.yml/badge.svg)](https://github.com/mtecfix/finance-tracker-ios/actions)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue)

---

## Features
- **Sinking Fund Engine** — allocate lump-sum payouts into named spending vaults
- **25% Tax Withholding** — auto-calculated on every income entry, shown separately
- **Income Vault** — lock money away for dry-spell months
- **Tax Reserve** — dedicated vault auto-tracked against withholding
- **RSU Tracker** — vault for equity compensation
- **Charts & Analysis** — income by month, expense by category, net position
- **Transaction History** — full log with income/expense/allocation types
- **Offline Mode** — all data cached locally, syncs when back online
- **Full Auth Flow** — sign up, email verification, forgot password, sign in

## AWS Backend
| Resource | Value |
|----------|-------|
| API Endpoint | `https://uiv731ay0h.execute-api.us-east-1.amazonaws.com/dev` |
| Cognito Pool | `us-east-1_Z3zNNwEQG` |
| Cognito Client | `2h50ha0j15j34n57p0gjpaqttp` |
| DynamoDB (Accounts) | `finance-primary` |
| DynamoDB (Transactions) | `finance-secondary` |
| S3 Bucket | `finance-663877906756` |
| Lambda | `finance-api` (Node.js 20) |

## API Routes
| Method | Route | Description |
|--------|-------|-------------|
| GET | `/accounts` | List all vaults |
| POST | `/accounts` | Create vault |
| PUT | `/accounts/{id}` | Update vault balance/name |
| DELETE | `/accounts/{id}` | Delete vault |
| GET | `/transactions` | List all transactions |
| POST | `/transactions` | Log income/expense (auto-calculates tax) |
| DELETE | `/transactions/{id}` | Delete transaction |

## Project Structure
```
FinanceApp/
├── Assets.xcassets/              ← App icon (placeholder — replace AppIcon-1024.png)
├── Config.swift
├── FinanceApp.swift              ← App entry + launch screen animation
├── Models/
│   ├── Account.swift             ← AccountType: sinking_fund | income_vault | tax_reserve | rsu_tracker
│   └── Transaction.swift         ← TransactionType: income | expense | allocation
├── Services/
│   ├── APIService.swift
│   ├── AuthService.swift
│   ├── LocalCache.swift
│   ├── NotificationManager.swift
│   └── OfflineBanner.swift
├── ViewModels/
│   └── AccountsViewModel.swift   ← Full CRUD + balance auto-update + offline cache
└── Views/
    ├── LaunchScreenView.swift    ← Deep green gradient + chart icon
    ├── ContentView.swift         ← 4 tabs: Dashboard, Vaults, Income, Charts
    ├── LoginView.swift
    ├── SignUpView.swift
    ├── ConfirmEmailView.swift
    ├── ForgotPasswordView.swift
    ├── DashboardView.swift       ← Balance summary, tax reserve, recent transactions
    ├── AccountsView.swift        ← Vault list with progress bars
    ├── AccountDetailView.swift   ← Vault transactions + log income button
    ├── AddAccountView.swift
    ← EditAccountView.swift
    ├── TransactionsView.swift    ← Full transaction history
    ├── LogIncomeView.swift       ← Log income or expense + tax calc
    └── FinanceChartsView.swift   ← Income bars, expense categories, net position
```

## Tax Withholding Logic
Every income entry automatically sets aside 25% for self-employment tax:
- Shown separately in transaction log
- Tracked in dedicated Tax Reserve vault
- Visible on dashboard at all times

## App Icon
Placeholder: `FinanceApp/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` (solid green).
Replace with your 1024×1024 PNG.

## Launch Screen
Deep green gradient with chart icon, fades out after 1.8s.

## Installing via AltStore
1. Download `.ipa` from GitHub Actions build artifacts
2. Open AltStore → tap `+` → select `.ipa`

## CI/CD
GitHub Actions builds on every push to `main` using macOS runner.
