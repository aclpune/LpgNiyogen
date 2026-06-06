# LPG Niyojan — Godown Keeper Application
# User Manual

---

> **Document Version:** 1.0
> **Prepared For:** Client Delivery / User Training
> **Platform:** Android Mobile Application
> **Module:** Godown Keeper
> **Date:** May 2026

---

*[Header: LPG Niyojan — Godown Keeper User Manual | Version 1.0 | Confidential]*
*[Footer: Page {N} | © Aadyam Infotech | LPG Niyojan Application]*

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
| — | 3.1 Godown Keeper Dashboard | {P} |
| — | 3.2 Bottom Navigation Bar | {P} |
| 4 | Daily Sale Module | {P} |
| — | 4.1 Delivery Men List Screen | {P} |
| — | 4.2 Daily Refill Sale Screen | {P} |
| — | 4.3 Adding Sale Items | {P} |
| — | 4.4 SV (Special Voucher) Consumer Entry | {P} |
| — | 4.5 TV (Transfer Voucher) Consumer Entry | {P} |
| — | 4.6 Imbalance Entry | {P} |
| — | 4.7 Less Empty Entry | {P} |
| — | 4.8 Saving Sale Data | {P} |
| 5 | Today's Summary Module | {P} |
| — | 5.1 Stock Submit to Manager Screen | {P} |
| — | 5.2 Submit Stock to Manager | {P} |
| 6 | Item Receipt Module | {P} |
| — | 6.1 Item Receipt Screen | {P} |
| — | 6.2 Adding Receipt Items | {P} |
| — | 6.3 Edit / Delete Item Receipt | {P} |
| 7 | Item Return Module | {P} |
| — | 7.1 Item Return Screen | {P} |
| 8 | EXMI / Rev-EMR Module | {P} |
| — | 8.1 Return EXMI / Rev-EMR | {P} |
| — | 8.2 Receipt EXMI List | {P} |
| 9 | Mark Defective Module | {P} |
| — | 9.1 Mark Defective Item Screen | {P} |
| 10 | SQC Register Module | {P} |
| — | 10.1 SQC Register Screen | {P} |
| — | 10.2 Adding SQC Entry | {P} |
| — | 10.3 File / Photo Upload | {P} |
| 11 | Imbalance Module | {P} |
| — | 11.1 Imbalance Entry Sheet | {P} |
| — | 11.2 Imbalance Transaction History | {P} |
| 12 | More Options Menu | {P} |
| 13 | Logout | {P} |
| 14 | Validations & Error Messages | {P} |
| 15 | Important Notes | {P} |

---
---

## 1. Introduction

**LPG Niyojan** is a mobile application for LPG distributors to manage daily godown operations from a smartphone.

The **Godown Keeper module** is used by the godown keeper to:

- Record daily refill cylinder sale entries for each delivery man
- Track filled, empty, defective, SV and TV quantities
- Record item receipts from the oil company
- Manage EXMI / Rev-EMR returns and receipts
- Mark cylinders as defective
- Register SQC (Safety Quality Control) entries with photo/file uploads
- Submit end-of-day stock summary to Manager
- Manage imbalance cylinder records

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

**Steps:**
1. Enter the OTP provided by your Web Admin
2. Tap **Verify**
3. On success, app loads the Godown Keeper Dashboard

**Notes:**
- OTP is not sent via SMS — it is generated in Web Admin
- Wrong OTP shows an error message

[Insert OTP Verification Screenshot Here]

---

### 2.4 How to Get OTP from Web Admin

1. Log in to the **LPG Niyojan Web Admin Panel**
2. Navigate to **Staff Master**
3. Find the Godown Keeper's record
4. View the **OTP** and share it with the user

[Insert Web Admin OTP Screenshot Here]

---
---

## 3. Dashboard Module

---

### 3.1 Godown Keeper Dashboard

After login, the **Godown Keeper Dashboard** is displayed as the main home screen.

**What you see:**
- Greeting header with today's date
- Stock summary cards showing:
  - Today's Opening Stock (Filled / Empty / Defective)
  - Current Stock details by item
  - Physical Stock Imbalance summary
  - SQC (Safety Quality Control) count cards
- Pull-to-refresh to reload all data

[Insert Godown Keeper Dashboard Screenshot Here]

---

### 3.2 Bottom Navigation Bar

The app has **4 tabs** in the bottom navigation bar:

| Tab | Label | Screen |
|-----|-------|--------|
| 1 | **Dashboard** | Godown Keeper home dashboard |
| 2 | **Daily Sale** | Delivery men list for daily sale entry |
| 3 | **Today's Summary** | Stock submitted to Manager summary |
| 4 | **More** | More options (Item Receipt, Return, Mark Defective, etc.) |

[Insert Bottom Navigation Screenshot Here]

---
---

## 4. Daily Sale Module

---

### 4.1 Delivery Men List Screen

**Access:** Tap **Daily Sale** in the bottom navigation bar.

**What you see:**
- List of all active delivery men for today
- Each card shows:
  - Delivery man's name (with avatar initial)
  - Total Sale quantity
- Tap any delivery man card to open their sale entry

[Insert Delivery Men List Screenshot Here]

---

### 4.2 Daily Refill Sale Screen

**Access:** Tap a delivery man card from the Daily Sale screen.

This is the main screen for entering daily cylinder sale data for a specific delivery man.

**Top section shows:**
- Delivery Man name
- Vehicle number (with picker)
- Delivery date (auto-filled with today)
- Remark field

**Sale entry table shows items added:**

| Column | Description |
|--------|-------------|
| **Item** | Cylinder type (e.g. 14.2 KG, 5 KG) |
| **Filled** | Number of filled cylinders taken |
| **SV** | Special Voucher quantity |
| **TV** | Transfer Voucher quantity |
| **Empty** | Number of empty cylinders returned |
| **Def.** | Defective cylinders returned |
| **Less Empty** | Less empty count |

[Insert Daily Refill Sale Screenshot Here]

---

### 4.3 Adding Sale Items

**Steps:**
1. Select **Item** from the dropdown (e.g. 14.2 KG)
2. Select **Delivery Boy** from the list
3. Enter **Filled** cylinder quantity
4. Enter **SV** quantity (if applicable)
5. Enter **TV** quantity (if applicable)
6. Enter **Empty** cylinder count (mandatory)
7. Enter **Defective** count (if any)
8. Enter **Less Empty** count (if any)
9. Tap **Add Item** button

**Validations:**
- Empty cylinder count is mandatory
- Filled quantity must not exceed current godown stock
- Less Empty quantity must not exceed Filled quantity
- SV quantity must not exceed Filled quantity
- Defective quantity must not exceed Filled quantity
- Same item cannot be added twice for the same delivery man on the same day

[Insert Add Item Screenshot Here]

---

### 4.4 SV (Special Voucher) Consumer Entry

When SV quantity > 0, a consumer selection panel appears at the bottom of the screen.

**Steps:**
1. Search for consumer by number or name
2. Select the consumer from the list
3. Enter the cylinder quantity for that consumer
4. Tap **Add** to add this consumer to the SV list
5. Repeat for multiple consumers

**Total SV quantity** across all selected consumers must match the SV qty entered.

[Insert SV Consumer Entry Screenshot Here]

---

### 4.5 TV (Transfer Voucher) Consumer Entry

When TV quantity > 0, a TV consumer selection panel appears.

**Steps:**
1. Search for TV consumer
2. Select consumer from the list
3. Enter quantity
4. Tap **Add**

**Total TV qty** must match the TV qty entered.

[Insert TV Consumer Entry Screenshot Here]

---

### 4.6 Imbalance Entry

If cylinder counts result in an imbalance (mismatch between opening stock, sale, and returns), the **Imbalance Sheet** opens.

**Fields in Imbalance Sheet:**

| Field | Description |
|-------|-------------|
| Item | Cylinder type |
| Imbalance Qty | Calculated mismatch quantity |
| Customer | Select customer responsible |
| Qty Against Customer | Quantity attributed to customer |
| Remark | Optional note |

**Actions:**
- **Add** → Saves imbalance entry
- **History** → View past imbalance transaction history

[Insert Imbalance Entry Screenshot Here]

---

### 4.7 Less Empty Entry

When Less Empty quantity > 0, a customer selection panel appears to record which customers did not return empty cylinders.

**Steps:**
1. Select customer from dropdown
2. Enter quantity
3. Tap **Add** to save the entry
4. Repeat for multiple customers

[Insert Less Empty Entry Screenshot Here]

---

### 4.8 Saving Sale Data

Once all items and entries are complete:

1. Review all added items in the table
2. Tap **Save** button
3. Data is saved to local database first
4. On successful API submission, success message is shown
5. If data was already submitted today, duplicate entry is prevented

**Edit / Delete:**
- Tap the edit icon on any row to modify the entry
- Tap delete to remove an entry (confirmation required)

[Insert Save Sale Screenshot Here]

---
---

## 5. Today's Summary Module

---

### 5.1 Stock Submit to Manager Screen

**Access:** Tap **Today's Summary** in the bottom navigation bar.

**What you see:**
- Summary of all stock data entered today by delivery man
- Grouped by delivery man
- Each entry shows: Item, Filled, SV, TV, Empty, Defective, Less Empty
- Search bar to filter by delivery man name
- **Submit to Manager** button

[Insert Today's Summary Screenshot Here]

---

### 5.2 Submit Stock to Manager

**Purpose:** Officially submit today's completed stock data to the Manager for review.

**Steps:**
1. Review all entries on the Today's Summary screen
2. Verify all quantities are correct
3. Tap **Submit to Manager**
4. Confirmation dialog appears
5. Tap **Yes** → Data is submitted to Manager

**Important:**
- Once submitted, entries move to a "done" state
- Submission triggers a day-end check and data save

[Insert Submit to Manager Screenshot Here]

---
---

## 6. Item Receipt Module

---

### 6.1 Item Receipt Screen

**Access:** More → Item Receipt / Return → **Item Receipt**

**Purpose:** Record cylinders received from the oil company / supplier.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Receipt Date | Auto-filled with today's date |
| Vehicle No. | Enter / select vehicle number |
| Item (row) | Select cylinder type |
| Quantity | Number received |

[Insert Item Receipt Screenshot Here]

---

### 6.2 Adding Receipt Items

**Steps:**
1. Date is auto-filled (change if needed)
2. Enter **Vehicle Number**
3. Select **Item** from dropdown
4. Enter **Quantity**
5. Tap **Add Item** to add another item row
6. Tap **Save** to submit receipt

**Validations:**
- Vehicle number is mandatory
- At least one item must be added
- Quantity must be a positive number
- Same item cannot be added twice in one receipt

[Insert Add Receipt Item Screenshot Here]

---

### 6.3 Edit / Delete Item Receipt

**From the receipt list:**
- Tap **Edit** on any record to update quantities
- Tap **Delete** with confirmation to remove a record

[Insert Edit Receipt Screenshot Here]

---
---

## 7. Item Return Module

---

### 7.1 Item Return Screen

**Access:** More → Item Receipt / Return → **Item Return**

**Purpose:** Record cylinders returned to the oil company / supplier.

**What you see:**
- List of all item receipt records eligible for return
- Pull-to-refresh to reload list
- **SQC** button (FAB) to open SQC Register

**Steps:**
1. View the list of receipts
2. Tap a record to process its return
3. Enter return quantities for each item
4. Tap **Save**

[Insert Item Return Screenshot Here]

---
---

## 8. EXMI / Rev-EMR Module

---

### 8.1 Return EXMI / Rev-EMR

**Access:** More → EXMI / Rev-EMR → **Return EXMI / Rev-EMR**

**Purpose:** Record return of EXMI (Exchange Minus Invoice) or Rev-EMR cylinders to the company.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Receipt Date | Auto-filled with today's date |
| Vehicle No. | Enter vehicle number |
| Item | Select cylinder type |
| Quantity | Return quantity |

**Steps:**
1. Date is auto-filled
2. Enter vehicle number
3. Select item and enter quantity
4. Tap **Add Item** for additional items
5. Tap **Save**

[Insert Return EXMI Screenshot Here]

---

### 8.2 Receipt EXMI List

**Access:** More → EXMI / Rev-EMR → **Receipt EXMI**

**Purpose:** View all previously recorded EXMI receipt entries.

**What you see:**
- List of all EXMI receipts with date, vehicle, items and quantities
- Status badge on each entry
- Edit / Delete actions available

[Insert EXMI List Screenshot Here]

---
---

## 9. Mark Defective Module

---

### 9.1 Mark Defective Item Screen

**Access:** More → Mark Defective → **Mark Defective**

**Purpose:** Record cylinders that have been identified as defective and need to be flagged.

**Form Fields:**

| Field | Description |
|-------|-------------|
| Date | Auto-filled with today's date |
| Item | Select cylinder type from dropdown |
| Defective Qty | Number of defective cylinders |
| Remark | Reason or note for marking defective |

**Steps:**
1. Select the item (cylinder type)
2. Enter defective quantity
3. Enter remark (reason)
4. Tap **Save**

**List View:** All previously marked defective records are shown below the form.

[Insert Mark Defective Screenshot Here]

---
---

## 10. SQC Register Module

---

### 10.1 SQC Register Screen

**Access:** Via the **SQC** FAB button on the Item Return screen.

**Purpose:** Record Safety Quality Control (SQC) checks for incoming cylinders. Each SQC entry can include photo or file attachments as evidence.

**What you see:**
- Hero header with current date
- SQC count summary cards:
  - Today: Truck In / SQC Done / Not Done / Body Leak / Less Qty
  - Month: Same categories
- List of all SQC entries
- **Add SQC Entry** button

[Insert SQC Register Screenshot Here]

---

### 10.2 Adding SQC Entry

**Form Fields:**

| Field | Description |
|-------|-------------|
| Item | Select cylinder type |
| Quantity | Number of cylinders inspected |
| Body Leak Qty | Cylinders with body leak |
| Less Qty Cyls | Cylinders with less quantity gas |
| SQC Status | Done / Not Done |
| Remark | Optional note |

**Steps:**
1. Select Item from dropdown
2. Enter cylinder quantities
3. Enter Body Leak and Less Qty counts (if any)
4. Set SQC Status
5. Add remark if needed
6. Attach photo/file (optional)
7. Tap **Save**

[Insert Add SQC Entry Screenshot Here]

---

### 10.3 File / Photo Upload in SQC

**Supported uploads:**
- **Camera Photo** — Take a live photo
- **Gallery Image** — Select from phone gallery
- **File Upload** — Pick a document (PDF, etc.)

**Limits:**
- Maximum file size: **5 MB**
- One attachment per SQC entry

**Steps:**
1. Tap the upload area or camera/file icon
2. Choose: Camera / Gallery / File
3. Selected file preview is shown
4. Submit the SQC entry with the attachment

[Insert SQC Upload Screenshot Here]

---
---

## 11. Imbalance Module

---

### 11.1 Imbalance Entry Sheet

**Access:** Automatically opens during Daily Sale entry when imbalance is detected, or via the Imbalance section.

**Purpose:** Record and track cylinder imbalances (mismatches between the cylinders given out and returned).

**Form Fields:**

| Field | Description |
|-------|-------------|
| Item | Cylinder type with imbalance |
| Imbalance Qty | Auto-calculated mismatch quantity (read-only) |
| Customer* | Select customer responsible for imbalance |
| Qty Against Customer* | Quantity attributed to that customer |
| Remark | Optional note |

Fields marked with **\*** are mandatory.

**Steps:**
1. Item and Imbalance Qty are auto-filled
2. Select the customer from dropdown
3. Enter quantity attributed to that customer
4. Add remark (optional)
5. Tap **Save**
6. Add more entries if imbalance spans multiple customers

[Insert Imbalance Entry Screenshot Here]

---

### 11.2 Imbalance Transaction History

**Access:** Tap **History** on the Imbalance Entry Sheet.

**What you see:**
- Complete history of imbalance entries for the selected item
- Each record shows: Date, Customer, Quantity, Status

[Insert Imbalance History Screenshot Here]

---
---

## 12. More Options Menu

**Access:** Tap **More** in the bottom navigation bar.

The More screen is organized into sections:

---

### Section: Item Receipt / Return

| Menu Item | Action |
|-----------|--------|
| **Item Receipt** | Opens Item Receipt entry screen |
| **Item Return** | Opens Item Return list screen |

---

### Section: EXMI / Rev-EMR

| Menu Item | Action |
|-----------|--------|
| **Return EXMI / Rev-EMR** | Opens EXMI Return entry screen |
| **Receipt EXMI** | Opens EXMI Receipt list screen |

---

### Section: Mark Defective

| Menu Item | Action |
|-----------|--------|
| **Mark Defective** | Opens Mark Defective entry screen |

---

### Section: Account

| Menu Item | Action |
|-----------|--------|
| **Logout** | Shows logout confirmation popup |

**Note:** Pull-to-refresh is available on this screen.

[Insert More Options Screenshot Here]

---
---

## 13. Logout

**Access:** More → Account → **Logout**

**Steps:**
1. Tap **Logout** (shown in red/orange)
2. A confirmation popup appears
3. Tap **Cancel** → stays on More screen
4. Tap **Logout** → logs out and goes to Login screen

**What happens on logout:**
- Version/activity record is updated via API
- Session data is cleared from app
- App navigates to Login screen

[Insert Logout Dialog Screenshot Here]

---
---

## 14. Validations & Error Messages

| Scenario | Message Shown |
|----------|---------------|
| No internet connection | *"No internet connection."* |
| Bearer token missing | *"Bearer token is missing"* (exception logged) |
| Empty cylinder field missing | *"Add Empty Cylinder Count!"* |
| Filled qty exceeds godown stock | Entry blocked; stock validation fails |
| SV qty exceeds Filled qty | Entry blocked by validation |
| Defective qty exceeds Filled qty | Entry blocked by validation |
| Item already added today (API check) | Duplicate entry prevented |
| Day-end already completed | *"Day end completed. Action restricted."* |
| Data list fetch failed | *"Failed To Load Items"* |
| API request failed | *"Request failed. Please try again."* |
| API returns 0 | *"Something went wrong. Please try again."* |
| File exceeds 5MB | Upload blocked; size limit error |

---
---

## 15. Important Notes

| # | Note |
|---|------|
| 1 | **Internet connection is required** for all API screens |
| 2 | **Daily sale data is saved locally first** (SQLite database) and then submitted via API |
| 3 | **Empty cylinder count is mandatory** when adding any sale item |
| 4 | **SV and TV consumer totals** must exactly match the SV/TV quantities entered |
| 5 | **Same item cannot be added twice** for the same delivery man on the same date |
| 6 | **Stock Transfer must be completed** before Daily Sale entries are allowed |
| 7 | **SQC photo/file size limit is 5 MB** — larger files will be rejected |
| 8 | **Imbalance sheet opens automatically** when there is a mismatch in cylinder counts |
| 9 | **Back button** on all sub-screens returns to the main bottom navigation bar |
| 10 | Contact your **system administrator** if login fails or OTP is not available |
| 11 | All financial/quantity data is specific to the **current day only** unless stated otherwise |
| 12 | **Day-end check** runs automatically — once day is closed, no further edits are allowed |

---
---

*[End of Document]*

*[Footer: LPG Niyojan — Godown Keeper User Manual | Version 1.0 | © Aadyam Infotech | Confidential]*

---

