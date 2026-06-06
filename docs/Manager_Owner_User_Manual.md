# LPG Niyojan — Manager / Owner Application
# User Manual

---

> **Document Version:** 1.0  
> **Prepared For:** Client Delivery / User Training  
> **Platform:** Android Mobile Application  
> **Module:** Manager & Owner  
> **Date:** May 2026  

---
---

*[Header: LPG Niyojan — Manager/Owner User Manual | Version 1.0 | Confidential]*  
*[Footer: Page {N} | © Aadyam Infotech | LPG Niyojan Application]*

---

---

## Table of Contents

| # | Module | Page |
|---|--------|------|
| 1 | Introduction | {P} |
| 2 | Login & Authentication | {P} |
| — | 2.1 Splash Screen | {P} |
| — | 2.2 Mobile Number Login | {P} |
| — | 2.3 OTP Verification | {P} |
| — | 2.4 Web Admin OTP Process | {P} |
| 3 | Dashboard Module | {P} |
| — | 3.1 Manager Dashboard | {P} |
| — | 3.2 Dashboard KPI Cards | {P} |
| — | 3.3 Trans Mode Filter | {P} |
| 4 | DSR (Daily Sales Report) Module | {P} |
| — | 4.1 DSR Screen Overview | {P} |
| — | 4.2 DSR Tabs | {P} |
| — | 4.3 Date Selection & Show DSR | {P} |
| 5 | Delivery / Update Sale Module | {P} |
| — | 5.1 Delivery Boy Wise List | {P} |
| — | 5.2 Update Sales Summary | {P} |
| — | 5.3 Cash Updation Screen | {P} |
| — | 5.4 Submit All Sales | {P} |
| 6 | SV Sale Module | {P} |
| 7 | TV Receipt Module | {P} |
| 8 | Payment Receipt Module | {P} |
| 9 | Update Payments Module | {P} |
| 10 | Salary Payments Module | {P} |
| 11 | Cash Handover / Bank Deposit Module | {P} |
| 12 | ARB Module | {P} |
| — | 12.1 ARB Purchase | {P} |
| — | 12.2 ARB Purchase Return | {P} |
| — | 12.3 ARB Sale | {P} |
| 13 | Receipt Defective Regulator Module | {P} |
| 14 | More Options (Menu) | {P} |
| 15 | Configuration Screen (Owner Only) | {P} |
| 16 | Logout | {P} |
| 17 | Validations & Error Messages | {P} |
| 18 | Important Notes | {P} |

---
---

## 1. Introduction

**LPG Niyojan** is a mobile application designed for LPG distributors to manage daily operations from a smartphone.

The **Manager/Owner module** provides complete control over:

- Daily cylinder sales and collection
- DSR (Daily Sales Report) generation
- Delivery boy performance tracking
- Expense management
- ARB (Additional/Returnable Bottle) operations
- Cash handover and bank deposit records
- Salary and vendor payment tracking
- TV/SV receipt management

**Prerequisites:**
- Active internet connection
- Registered mobile number
- OTP issued by Web Admin

---
---

## 2. Login & Authentication Module

---

### 2.1 Splash Screen

When you open the app, the Splash Screen appears first.

**What happens:**
- App logo and name are displayed
- App checks for an existing active session
- If already logged in → goes directly to Dashboard
- If not logged in → goes to Login Screen

[Insert Splash Screen Screenshot Here]

---

### 2.2 Mobile Number Login

**Screen:** Login Screen

**Steps:**
1. Enter your registered **10-digit mobile number**
2. Tap **Submit / Send OTP**
3. The system validates the number against the database
4. On success, you are taken to the OTP screen

**Validations:**
- Mobile number is mandatory
- Must be exactly 10 digits
- Number must be registered in Web Admin

[Insert Mobile Number Login Screenshot Here]

---

### 2.3 OTP Verification

**Screen:** Verify OTP

**Steps:**
1. Enter the OTP provided by your Web Admin
2. Tap **Verify**
3. On success, app loads your role-based dashboard

**Notes:**
- OTP is not sent via SMS — it is generated in Web Admin
- OTP is role-based and time-limited
- Wrong OTP shows an error message

[Insert OTP Verification Screenshot Here]

---

### 2.4 How to Get OTP from Web Admin

**For Admin / Web Portal Users:**

1. Log in to the **LPG Niyojan Web Admin Panel**
2. Navigate to **Staff Master**
3. Find the staff member who needs to log in
4. Click on their record to view the **OTP**
5. Share the OTP with the staff member for mobile login

[Insert Web Admin Staff Master Screenshot Here]

---
---

## 3. Dashboard Module

---

### 3.1 Manager Dashboard Screen

After login, the **Manager Dashboard** is the main home screen.

**What you see:**
- Hero header strip with greeting (Good Morning/Afternoon/Evening) and your name
- Today's date
- Trans Mode filter (Today's / This Month / Financial Year)
- KPI summary cards
- Delivery men count section
- Revenue / Profit section
- Cash & settlement summaries
- Stock progress section
- Bottom navigation bar (Dashboard | DSR | Delivery | More)

[Insert Manager Dashboard Screenshot Here]

---

### 3.2 Dashboard KPI Cards

The dashboard shows the following information cards:

| Card | Description |
|------|-------------|
| **SV Count** | Pending SV (Special Voucher) cylinders |
| **TV Count** | TV (Transfer Voucher) receipts |
| **PostPaid Pending** | Pending postpaid verifications |
| **Credit Outstanding** | Total outstanding credit amount |
| **ARB Revenue** | Revenue from ARB sales |
| **Refill Revenue** | Revenue from refill cylinder sales |
| **Imbalance** | Cylinder imbalance count |
| **Unsettled** | Unsettled sale entries |
| **Cash Summary** | Today's cash movement summary |
| **Prepaid Booking** | Prepaid bookings count |
| **Punching Summary** | Booking punching status |
| **Cash Handover** | Cash handover records |
| **Payment Receipt** | Payment receipts summary |

**Action:** Tap any card → Opens detailed list screen for that data.

[Insert Dashboard KPI Cards Screenshot Here]

---

### 3.3 Trans Mode Filter

The filter at the top of the dashboard controls which time period data is shown.

| Option | Shows data for |
|--------|----------------|
| **Today's** | Current date only |
| **This Month** | Current calendar month (default) |
| **Financial Year** | Full financial year |

**Steps:** Tap any filter chip → Dashboard refreshes automatically.

[Insert Trans Mode Filter Screenshot Here]

---
---

## 4. DSR (Daily Sales Report) Module

---

### 4.1 DSR Screen Overview

**Access:** Tap **DSR** in the bottom navigation bar.

The DSR screen shows a complete daily summary of all transactions for the selected date.

**Top section shows:**
- Current date (auto-loaded on open)
- Date picker button to change date
- **Show DSR** button to load data for selected date

[Insert DSR Overview Screenshot Here]

---

### 4.2 DSR Tabs

The DSR screen contains **6 tabs**. Tap any tab to view that section:

| Tab | What it shows |
|-----|---------------|
| **Revenue** | Income from sales, settled/unsettled breakdown |
| **DM Sale** | Delivery man-wise sale summary |
| **Expenses** | All recorded expenses for the day |
| **SV & TV** | Special Voucher and Transfer Voucher details |
| **CDCMS Stock** | Current cylinder stock status |
| **Cash** | Cash-in-hand and denomination details |

**Clickable items in each tab:** Tap any item/row → Opens a detailed transactions screen.

[Insert DSR Tabs Screenshot Here]

---

### 4.3 Date Selection & Show DSR

**To view DSR for a different date:**
1. Tap the **Select Date** option
2. Choose a date from the calendar (future dates are disabled)
3. Tap **Show DSR**
4. All 6 tabs refresh with data for the selected date

**Note:** By default, today's data is shown automatically when you open the DSR screen.

[Insert Date Picker Screenshot Here]

---
---

## 5. Delivery / Update Sale Module

---

### 5.1 Delivery Boy Wise List

**Access:** Tap **Delivery** in the bottom navigation bar.

**What you see:**
- List of all delivery men who have active sales for the day
- Each card shows: Staff name, vehicle number, receipt date, sale GK ID
- Tap any delivery man card to open their sale details

[Insert Delivery Boy List Screenshot Here]

---

### 5.2 Update Sales Summary Screen

**Access:** Tap a delivery man card from the Delivery screen.

**Top Info Card shows:**
- Receipt Number
- Receipt Date
- Delivery Man name
- Vehicle Number
- Total Expense Amount

**Sale Items List:**
Each item card shows:

| Field | Description |
|-------|-------------|
| **Item Name** | Product (e.g. 14.2 KG) |
| **User Name** | Delivery man |
| **Sale** | GD Filled Sale quantity |
| **Act. Sale** | Actual Sale quantity |
| **TV** | Transfer Voucher quantity |
| **SV** | Special Voucher quantity (tap to see consumer details) |
| **Def.** | Defective quantity |
| **Amount** | Total sale amount |
| **Received Amt.** | Cash denomination received |

**View More / View Less:** Tap to expand/collapse payment breakdown (Cash / Online-Prepaid / Merchant QR / Credit).

**Action Buttons on each item:**

| Button | Condition | Action |
|--------|-----------|--------|
| **Update** | No payment entered yet, actual sale > 0 | Opens Cash Updation in Add mode |
| **Edit** | Payment already entered | Opens Cash Updation in Edit mode |
| **No Cash** | Actual sale = 0 or SV-only | Opens settle confirmation dialog |

[Insert Update Sales Summary Screenshot Here]

---

### 5.3 Cash Updation Screen

**Access:** Tap **Update** or **Edit** on a sale item.

**Sections:**

1. **Sale Info** — Item name, delivery man, quantities (Sale/SV/TV/Def)
2. **Payment Mode Split** — Enter qty and amount for:
   - Cash
   - Prepaid / Online
   - Merchant QR (Postpaid)
   - Credit
3. **Cash Denomination** — If Cash mode selected, enter denomination-wise cash received
4. **Balance Calculation** — Auto-calculated expected, received, and balance amounts
5. **Save / Update Button** — Submit the payment details

**Validations:**
- Total of all mode quantities must equal actual sale quantity
- Cash denomination total must match cash amount
- Amount fields accept decimal values only

[Insert Cash Updation Screenshot Here]

---

### 5.4 Submit All Sales (FAB Button)

**Purpose:** Settle all pending SV-only sale items in one tap (items where no cash payment has been entered).

**How to use:**
1. On the Update Sales Summary screen, look at the bottom-right **floating button**
2. Button shows: **Submit All (N)** — where N = number of unsettled items
3. Tap the button
4. A confirmation dialog appears showing item count and delivery man name
5. Tap **Yes, Submit** → All unsettled items are marked as settled (flag = 13)
6. On success → navigates back to main screen with success message

**Button States:**

| State | Label | Color |
|-------|-------|-------|
| Items to settle | Submit All (N) | Blue |
| All already settled | All Settled | Grey (disabled) |
| Processing | Submitting… | Blue with spinner |

**Validation messages shown if:**
- No items are loaded yet
- Some items have payment details entered but not yet fully settled (use Edit → Save first)
- All items are already settled

[Insert Submit All Sales Screenshot Here]

---
---

## 6. SV Sale Module

**Access:** More → Daily Transaction → **SV Sale**

**Purpose:** Record sale entries for Special Voucher (SV) cylinders.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Staff | Select delivery man |
| Consumer No. | SV consumer number |
| Transaction Mode | Cash / Merchant QR / Partial |
| Transaction Account | NC / RC / DBC |
| Stamp Duty | Enter applicable stamp duty amount |
| Cash Denomination | Denomination-wise cash entry (if Cash mode) |

**List View:** All saved SV sale records are listed below the form.

**Actions on each record:**
- **Edit** → Pre-fills the form with existing data
- **Delete** → Confirmation popup → removes the record

[Insert SV Sale Screenshot Here]

---
---

## 7. TV Receipt Module

**Access:** More → Daily Transaction → **TV Receipt**

**Purpose:** Record TV (Transfer Voucher) cylinder receipts from the oil company.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Consumer No. | Consumer number |
| Consumer Name | Name of consumer |
| Cyl. Holding Qty | Current cylinder holding quantity |
| Payment Amount | Amount received |
| Regulator Received | Yes / No |
| Transaction Mode | Cash / Online |
| Transaction Code | Reference code |

**List View:** All saved TV receipt records.

**Actions:** Edit and Delete each record.

[Insert TV Receipt Screenshot Here]

---
---

## 8. Payment Receipt Module

**Access:** More → Daily Transaction → **Payments Receipt**

**Purpose:** Record cash or bank payment receipts from customers or distributors.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Transaction Mode | Cash / Cheque / Online / Bank Transfer |
| Staff Mode | Staff / Reticulated / Other |
| Customer Mode | Exempted / ND / POS |
| Bank | Select relevant bank |
| Receipt No. | Auto-generated |
| Cash Denomination | If Cash mode — enter denomination breakdown |

**List View:** All payment receipt records with ability to Edit/Delete.

[Insert Payment Receipt Screenshot Here]

---
---

## 9. Update Payments Module

**Access:** More → Daily Transaction → **Update Payments**

**Purpose:** Record and update vendor or staff payment entries (expenses paid out).

**Form Fields:**

| Field | Description |
|-------|-------------|
| Payment Against | Staff / Vendor |
| Staff / Vendor Name | Select from dropdown |
| Balance | Auto-populated from system |
| Transaction Code | Reference number |
| Transaction Mode | Cash / Online |
| Cash Denomination | If Cash mode |
| Remark | Optional note |

**List View:** All payment records, editable and deletable.

[Insert Update Payments Screenshot Here]

---
---

## 10. Salary Payments Module

**Access:** More → Daily Transaction → **Salary Payments**

**Purpose:** Record salary, commission, incentive, or advance payments to staff.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Paid Against | Commission / Salary / Incentive / Advance |
| Staff | Select staff member |
| Transaction Mode | Cash / Online |
| Vendor Name | If vendor payment |
| Remark | Optional note |
| Cash Denomination | If Cash mode |

**List View:** All salary payment records.

[Insert Salary Payments Screenshot Here]

---
---

## 11. Cash Handover / Bank Deposit Module

**Access:** More → Daily Transaction → **Cash Handover-Bank Deposit**

**Purpose:** Record cash handed over to bank or ATM.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Staff | Select staff member |
| Bank | Select bank |
| Mode | ATM Deposit / Branch Deposit |
| Date | Select deposit date |
| Denomination | Enter denomination-wise cash |
| Total | Auto-calculated from denomination |

**List View:** All handover records.

[Insert Cash Handover Screenshot Here]

---
---

## 12. ARB Module

ARB stands for **Additional Returnable Bottle** — non-standard cylinder-related operations.

---

### 12.1 ARB Purchase

**Access:** More → ARB → **ARB Purchase**

**Purpose:** Record purchases of ARB items from vendors.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Invoice Number | Purchase invoice reference |
| Vendor | Select vendor from list |
| Mobile No. | Vendor contact number |
| Item | Select ARB item |
| Transaction Mode | Cash / Online |
| Basic Amount | Item base price |
| Tax Amount | Applicable tax |
| Net Amount | Auto-calculated |
| Date | Purchase date |

**Add Payment List:** Tap **Add Payment** to record multiple payment entries against the same purchase.

**List View:** All ARB purchase records.

[Insert ARB Purchase Screenshot Here]

---

### 12.2 ARB Purchase Return

**Access:** More → ARB → **ARB Purchase Return**

**Purpose:** Record return of ARB items to vendor.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Vendor | Select from dropdown |
| Item | Select ARB item to return |
| Quantity | Number of items returned |
| Return Date | Date of return |

**List View:** All ARB return records.

[Insert ARB Purchase Return Screenshot Here]

---

### 12.3 ARB Sale

**Access:** More → ARB → **ARB Sale**

**Purpose:** Record sales of ARB items to customers.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Item | Select ARB item |
| Customer | Select customer |
| Quantity | Sale quantity |
| Transaction Mode | Cash / Online |
| Amount | Sale amount |

**Actions:** Edit and Delete each sale record.

[Insert ARB Sale Screenshot Here]

---
---

## 13. Receipt Defective Regulator Module

**Access:** More → Daily Transaction → **Receipt Defective Regulator**

**Purpose:** Record receipt of defective regulators returned from the field.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Staff | Select delivery man |
| Regulator Item | Select item type |
| Consumer No. | Consumer number |
| Payment Amount | Amount received (if any) |
| Regulator Received | Yes / No |
| Transaction Mode | Cash / Online |

**List View:** All defective regulator receipt records with Edit option.

[Insert Defective Regulator Screenshot Here]

---
---

## 14. More Options Menu

**Access:** Tap **More** in the bottom navigation bar.

The More screen is organized into sections:

### Section: Admin Settings *(Owner role only)*

| Menu Item | Action |
|-----------|--------|
| **Configuration** | Opens system configuration settings |

### Section: Daily Transaction

| Menu Item | Navigates to |
|-----------|-------------|
| SV Sale | SV Sale entry screen |
| TV Receipt | TV Receipt entry screen |
| Payments Receipt | Payment Receipt screen |
| Update Payments | Update Payments screen |
| Salary Payments | Salary Payment screen |
| Cash Handover-Bank Deposit | Cash Handover screen |
| Receipt Defective Regulator | Defective Regulator screen |

### Section: ARB

| Menu Item | Navigates to |
|-----------|-------------|
| ARB Purchase | ARB Purchase screen |
| ARB Purchase Return | ARB Return screen |
| ARB Sale | ARB Sale screen |

### Section: Account

| Menu Item | Action |
|-----------|--------|
| **Logout** | Shows logout confirmation popup |

**Note:** Pull-to-refresh is available on this screen.

[Insert More Options Menu Screenshot Here]

---
---

## 15. Configuration Screen *(Owner Only)*

**Access:** More → Admin Settings → **Configuration**

**Visible only when:** Logged in with **Owner** role.

This screen allows the Owner to manage system-level settings for the distributor account.

*(Specific configuration options depend on what has been enabled by the system administrator.)*

[Insert Configuration Screenshot Here]

---
---

## 16. Logout

**Access:** More → Account → **Logout**

**Steps:**
1. Tap **Logout** (shown in red)
2. A confirmation popup appears:
   - **"Are you sure you want to logout?"**
3. Tap **Cancel** → stays on More screen
4. Tap **Logout** (red button) → logs out and goes to Login screen

**What happens on logout:**
- App deactivates the device notification token
- Session data is cleared from the app
- App navigates to the Splash/Login screen

[Insert Logout Dialog Screenshot Here]

---
---

## 17. Validations & Error Messages

| Scenario | Message Shown |
|----------|---------------|
| No internet connection | *"No internet connection. Please check your network."* |
| Bearer token missing / expired | *"Session expired. Please login again."* |
| API request failed | *"Request failed. Please try again."* |
| API returns 0 | *"Something went wrong. Please try again."* |
| Sale item list empty | *"No sale items loaded. Please wait for data to load."* |
| Submit with pending edits | *"Some items have payment details entered but are not yet settled. Please tap Edit on each item and save before submitting all."* |
| All items already settled | *"All sale items are already settled. Nothing to submit."* |
| Data list fetch failed | *"Failed to get list."* |
| Required fields empty | Field-level validation message shown inline |
| Wrong OTP | OTP verification error shown on screen |

---
---

## 18. Important Notes

| # | Note |
|---|------|
| 1 | **Internet connection is required** for all screens — data is loaded from live APIs |
| 2 | **OTP is not sent via SMS** — it must be obtained from the Web Admin portal |
| 3 | Only **registered mobile numbers** can log in |
| 4 | The **Configuration** menu is visible **only to Owner role** |
| 5 | **Cash Denomination total** must match the cash amount entered |
| 6 | **Submit All Sales** only settles SV-only items (no-cash sales); items with entered payment must be saved individually |
| 7 | The **DSR screen** auto-loads today's data; use "Show DSR" after changing the date |
| 8 | **Back button** on most screens returns to the main navigation bar, not the previous screen |
| 9 | Contact your **system administrator** if login fails or OTP is not available |
| 10 | All financial amounts are displayed in **Indian Rupee (₹) format** |

---
---

*[End of Document]*

*[Footer: LPG Niyojan — Manager/Owner User Manual | Version 1.0 | © Aadyam Infotech | Confidential]*

---

