# Finance Tracker iOS

Personal finance app built for irregular income earners — freelancers, gig workers, and RSU recipients.

## Features
- **Sinking Fund Engine** — allocate lump-sum payouts into future spending vaults
- **Tax Withholding** — auto-calculates 25% tax reserve on every income entry
- **Income Vault** — lock away money for dry spells
- **RSU Tracker** — track equity vesting schedules
- **Transaction Log** — full history with category and date

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
| GET | `/accounts` | List all vaults/accounts |
| POST | `/accounts` | Create a new vault |
| GET | `/transactions` | List all transactions |
| POST | `/transactions` | Log income or expense (auto-calculates tax) |

## Project Structure
```
FinanceApp/
├── Config.swift                  — API endpoints, Cognito IDs
├── FinanceApp.swift              — App entry point
├── Models/
│   ├── Account.swift             — Account/vault model + AccountType enum
│   └── Transaction.swift         — Transaction model + TransactionType enum
├── Services/
│   └── APIService.swift          — All HTTP calls
├── ViewModels/
│   └── AccountsViewModel.swift   — Accounts + transactions state
└── Views/
    ├── ContentView.swift         — Auth gate + tab navigation
    ├── DashboardView.swift       — Balance overview + recent activity
    ├── AccountsView.swift        — Vault list
    ├── AddAccountView.swift      — Create vault form
    ├── TransactionsView.swift    — Transaction history
    ├── LogIncomeView.swift       — Log income with tax calc
    ├── LoginView.swift           — Sign in
    ├── SignUpView.swift          — Create account
    ├── ConfirmEmailView.swift    — Email verification
    └── ForgotPasswordView.swift  — Password reset
```

## Getting Started
1. Open `Package.swift` in Xcode 15+
2. Build and run on iOS 16+ simulator or device
3. Sign in or create an account
4. Add your first vault and log income

## Tax Withholding Logic
Every income entry automatically calculates 25% for self-employment tax and displays it separately, helping you never be caught short at tax time.

## CI/CD
GitHub Actions builds automatically on every push to `main` using macOS runner.

## Installing via AltStore
1. Download the `.ipa` from the latest GitHub Actions build artifact
2. Open AltStore on your iPhone → tap `+` → select the `.ipa`
