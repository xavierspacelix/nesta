# UI Registry

## Baseline — Established 2026-06-17

*Note: This baseline was established via /imprint*

| Property           | Token / Value              |
| ------------------ | -------------------------- |
| Card background    | Colors.white               |
| Card border        | AppTheme.neutral200        |
| Card radius        | BorderRadius.circular(16)  |
| Sheet radius       | BorderRadius.circular(20) top |
| Section bg         | AppTheme.neutral50         |
| Info container bg  | AppTheme.primary.withOpacity(0.05) |
| Success bg         | AppTheme.success.withOpacity(0.08) |
| Warning bg         | AppTheme.warning.withOpacity(0.08) |
| Button primary     | AppTheme.primary           |
| Button success     | AppTheme.success           |
| Text primary       | fontWeight: FontWeight.w700, fontSize: 16 |
| Text body          | fontSize: 14               |
| Text label         | fontSize: 13, color: AppTheme.neutral500 |
| Text caption       | fontSize: 12, color: AppTheme.neutral500 |
| Text muted         | fontSize: 11, color: AppTheme.neutral500 |
| Padding card       | EdgeInsets.all(16)         |
| Padding section    | EdgeInsets.all(24)         |
| Padding tile       | EdgeInsets.symmetric(horizontal: 12, vertical: 10) |
| Spacing gap        | SizedBox(height: 12)       |
| Status badge       | borderRadius: 100, padding: symmetric(h: 10, v: 4) |

## Rent Month Card

File: `lib/features/finance/screens/rent_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Background       | Colors.white                   |
| Border           | AppTheme.neutral200            |
| Border radius    | BorderRadius.circular(16)      |
| Shadow           | neutral200.withOpacity(0.3)    |
| Padding          | EdgeInsets.all(16)             |
| Header bg (lunas) | AppTheme.success.withOpacity(0.05) |
| Info bg          | AppTheme.neutral50             |
| Info radius      | BorderRadius.circular(12)      |

**Pattern notes:**
Each month's rent data is displayed in a white card with subtle border and shadow. Status badge uses pill shape (borderRadius: 100).

## Member Payment Tile

File: `lib/features/finance/screens/rent_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Padding          | EdgeInsets.symmetric(horizontal: 12, vertical: 10) |
| Radius           | BorderRadius.circular(8)       |
| Paid bg          | AppTheme.success.withOpacity(0.05) |
| Pending bg       | AppTheme.warning.withOpacity(0.05) |
| Avatar bg        | AppTheme.primary.withOpacity(0.15) |
| Status badge     | borderRadius: 100             |

**Pattern notes:**
Tile background shifts based on payment status. Status label uses pill badge with matching color icon.

## Category Card

File: `lib/features/finance/screens/financial_dashboard_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Background       | Colors.white                   |
| Border           | AppTheme.neutral200            |
| Border radius    | BorderRadius.circular(16)      |
| Shadow           | neutral200.withOpacity(0.3), blur 8, offset (0,2) |
| Padding          | EdgeInsets.all(16)             |
| Icon container  | 44x44, color.withOpacity(0.1), borderRadius: 12 |
| Icon size        | 22                             |
| Label text       | FontWeight.w600, fontSize: 15  |
| Subtitle text    | fontSize: 12, color: neutral500 |
| Trailing text    | FontWeight.w700, fontSize: 15, color: color |
| Chevron          | chevron_right_rounded, neutral400, size: 20 |

**Pattern notes:**
Row layout with icon container on left, label+subtitle column in middle, colored amount + chevron on right. Used for navigational cards (Denda, Galon, Listrik).

## Month Selector

File: `lib/features/finance/screens/financial_dashboard_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Background       | Colors.white                   |
| Border           | AppTheme.neutral200            |
| Border radius    | BorderRadius.circular(12)      |
| Padding          | EdgeInsets.symmetric(h: 12, v: 8) |
| Arrow btn bg     | AppTheme.neutral100, borderRadius: 8, padding: 8 |
| Arrow icon       | 20, disabled: neutral300, enabled: neutral600 |
| Month text       | FontWeight.w700, fontSize: 16  |
| Subtitle text    | fontSize: 11, color: neutral500 |

## Expense Analytics Card

File: `lib/features/finance/screens/financial_dashboard_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Background       | Colors.white                   |
| Border           | AppTheme.neutral200            |
| Border radius    | BorderRadius.circular(16)      |
| Shadow           | neutral200.withOpacity(0.3), blur 8, offset (0,2) |
| Padding          | EdgeInsets.all(20)             |
| Header icon bg   | primary.withOpacity(0.1), 36x36, borderRadius: 10 |
| Header icon      | 20                             |
| Dot indicator    | 8x8, shape: BoxShape.circle    |
| Row label        | fontSize: 13                   |
| Row amount       | FontWeight.w600, fontSize: 14  |
| Total label      | FontWeight.w700, fontSize: 16  |
| Total amount     | FontWeight.w700, fontSize: 18, color: primary |

**Pattern notes:**
Section header with icon container + title, followed by expense rows with colored dot indicators, divider, then total row. Conditional rows based on value > 0.

## Schedule View Toggle

File: `lib/features/schedule/screens/schedule_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Container bg     | AppTheme.neutral100            |
| Container radius | BorderRadius.circular(14)      |
| Container padding| EdgeInsets.all(4)              |
| Container height | 44                             |
| Pill bg          | Colors.white                   |
| Pill radius      | BorderRadius.circular(10)      |
| Pill shadow      | black.withOpacity(0.06), blur 8, offset (0,2) |
| Item icon        | 15, selected: primary, unselected: neutral500 |
| Item label       | fontSize: 13, fontWeight: w600, selected: primary, unselected: neutral500 |
| Animation        | AnimatedPositioned 250ms easeInOutCubic, AnimatedOpacity 200ms |

**Pattern notes:**
Segmented control with animated sliding pill. Three options: Harian (today), Mingguan (weekly), Bulanan (monthly). Icon + label row centered in each segment.

## Dashboard Stat Card

File: `lib/features/dashboard/screens/dashboard_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Background       | AppTheme.neutral50             |
| Border radius    | BorderRadius.circular(16)      |
| Padding          | EdgeInsets.all(16)             |
| Icon size        | 24                             |
| Value text       | headlineSmall, fontWeight: w700 |
| Label text       | bodySmall, color: neutral500   |

**Pattern notes:**
Simple card with icon on top, large value in middle, small label below. Used for quick stats (Tugas Selesai, Denda Tertunggak, dll).

## Bottom Sheet — Payment Action

File: `lib/features/finance/screens/rent_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Top radius       | BorderRadius.vertical(top: Radius.circular(20)) |
| Padding          | EdgeInsets.all(24)             |
| Divider bar      | Container: 40x4, neutral300, borderRadius: 2 |
| Amount bg        | AppTheme.primary.withOpacity(0.05), radius: 14 |
| Primary amount   | fontWeight: w700, fontSize: 24, color: primary |
| Detail text      | fontSize: 13, color: neutral500 |
| Bank info        | fontSize: 14, color: neutral600 |

**Pattern notes:**
Bottom sheet shows member avatar (CircleAvatar, radius 16), amount breakdown, and bank info. Action buttons full-width, height 52, radius 14.

## Status Cards (Paid / Pending / Verify / Upload)

File: `lib/features/finance/screens/rent_screen.dart`
Last updated: 2026-06-17

| Property         | Value                          |
| ---------------- | ------------------------------ |
| Padding          | EdgeInsets.all(16)             |
| Radius           | BorderRadius.circular(14)      |
| Success card bg  | AppTheme.success.withOpacity(0.08) |
| Success border   | AppTheme.success.withOpacity(0.3) |
| Warning card bg  | AppTheme.warning.withOpacity(0.08) |
| Warning border   | AppTheme.warning.withOpacity(0.3) |
| Button height    | 52                             |
| Button radius    | BorderRadius.circular(14)      |
| Proof image      | height: 120-140, width: full, radius: 12 |

**Pattern notes:**
Status cards are full-width with matching background tint and border. Proof image uses AuthImage widget with rounded corners.
