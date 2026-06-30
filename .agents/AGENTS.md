# Cloud-Billr Project Context & Rules

## Project Overview
**Cloud-Billr** is a cross-platform, offline-first invoice maker application built with Flutter. It helps freelancers and small businesses generate professional invoices using pre-defined templates, customize them with branding (logo, company name, address), calculate taxes, and store them locally with scheduled cloud backup.

## Tech Stack & Architecture
- **Framework:** Flutter
- **State Management:** Provider
- **Design System:** Custom layout using `AppColorScheme` and `AppSpacing` / `AppRadius` configurations.
- **Project Structure:**
  - `lib/models/`: Data models (e.g. `InvoiceModel`).
  - `lib/controllers/`: ChangeNotifiers/Providers handling business logic.
  - `lib/views/`: Feature-oriented UI views (e.g. `home/`, `create_invoice/`, `past_invoices/`, `settings/`).
  - `lib/utils/`: Theme, spacing, and color schemes.
  - `lib/helpers/`: Utility functions and helper modules.

## UI Design Guidelines
- Keep elements aligned with the custom `appColors` (globally defined) and the layout system defined in `theme.dart`.
- Ensure standard text scaling and responsive spacing using `AppSpacing` values.
- Follow the clean, light/dark aesthetic matching the Figma designs.
- Implement reusable custom widgets instead of inline duplicates.
