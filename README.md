# fundnest
A simple iOS app for tracking savings goals by account, amount, and currency.

## Overview

Fundnest is a SwiftUI iOS app for managing savings projects. Each project can
contain multiple account entries with independent currencies. The app converts
those entries into the project's summary currency and shows the total on both
the project list and detail screen.

## Features

- Project list with quick project creation.
- Project detail screen with total savings and account rows.
- Edit mode for project name, summary currency, account name, amount, and currency.
- Settings screen for default currency, manual exchange-rate refresh, app version,
  and build time.
- Local JSON persistence for projects, settings, and cached exchange rates.
- Core money calculation covered by Swift Package tests.

## Project layout

- `fundnest.xcodeproj`: SwiftUI iOS app project.
- `FundnestApp`: iOS app state, persistence, views, and assets.
- `Sources/FundnestCore`: portable models, exchange-rate table, formatting, and
  money calculation.
- `Tests/FundnestCoreTests`: unit tests for core calculations.

## Development

Open the app in Xcode:

```sh
open fundnest.xcodeproj
```

Run core tests:

```sh
swift test
```

This repository also includes a `Package.swift` so the core logic can be tested
without building the iOS app target.
