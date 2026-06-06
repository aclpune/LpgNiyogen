// import 'package:flutter/material.dart';
// import 'app_colors.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SPACING
// // ─────────────────────────────────────────────────────────────────────────────
//
// /// 4-pt grid spacing constants.
// /// Usage: SizedBox(height: AppSpacing.md)
// ///        Padding(padding: AppSpacing.cardPadding)
// class AppSpacing {
//   AppSpacing._();
//
//   static const double xxs  = 2.0;
//   static const double xs   = 4.0;
//   static const double sm   = 8.0;
//   static const double md   = 12.0;
//   static const double lg   = 16.0;
//   static const double xl   = 24.0;
//   static const double xxl  = 32.0;
//   static const double xxxl = 48.0;
//
//   // ── Pre-composed EdgeInsets ───────────────────────
//   static const EdgeInsets cardPadding      = EdgeInsets.all(lg);
//   static const EdgeInsets pagePadding      = EdgeInsets.fromLTRB(lg, 0, lg, xxl);
//   static const EdgeInsets chipPadding      = EdgeInsets.symmetric(horizontal: md, vertical: xs);
//   static const EdgeInsets rowPadding       = EdgeInsets.symmetric(horizontal: lg, vertical: sm + xs);
//   static const EdgeInsets sectionHeader    = EdgeInsets.fromLTRB(0, xxl, 0, sm);
//   static const EdgeInsets stockChip        = EdgeInsets.symmetric(vertical: 14, horizontal: 10);
//   static const EdgeInsets buttonPadding    = EdgeInsets.symmetric(horizontal: 14, vertical: 6);
//
//   // ── Delivery men list screen ──────────────────────
//   /// Horizontal + vertical padding for the search bar container.
//   static const EdgeInsets searchBarPadding = EdgeInsets.fromLTRB(lg, md, lg, md);
//   /// Padding applied to the scrollable list of delivery men items.
//   static const EdgeInsets listPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
//   /// Internal padding of each delivery man card row.
//   static const EdgeInsets deliveryCardPadding = EdgeInsets.symmetric(horizontal: lg, vertical: 14);
//   /// Hero header inner padding.
//   static const EdgeInsets heroHeaderPadding = EdgeInsets.fromLTRB(20, 16, 20, 20);
//   /// Count badge inside the hero header.
//   static const EdgeInsets heroBadgePadding = EdgeInsets.symmetric(horizontal: md, vertical: 6);
//
//   // ── Stock / Transfer screens ──────────────────────
//   /// Main body scroll padding for stock forms (DailyRefillSalePage, StockTransfer).
//   static const EdgeInsets formBodyPadding       = EdgeInsets.fromLTRB(16, 16, 16, 32);
//   /// Inner padding of form-card and summary-card containers.
//   static const EdgeInsets formCardPadding       = EdgeInsets.all(18);
//   /// Inner padding of each stock history list item.
//   static const EdgeInsets stockItemPadding      = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
//   /// Padding for the imbalance / less-empty warning panel.
//   static const EdgeInsets warningPanelPadding   = EdgeInsets.all(md);
//   /// Padding for small inline action buttons (Select Customer, etc.).
//   static const EdgeInsets inlineActionPadding   = EdgeInsets.symmetric(horizontal: 10, vertical: 6);
//   /// Padding for AppBar secondary TextButton actions.
//   static const EdgeInsets appBarActionPadding   = EdgeInsets.symmetric(horizontal: lg, vertical: 10);
//   /// Padding inside stock-count chips in summary cards.
//   static const EdgeInsets stockChipInner        = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   /// Padding inside compact stock badges on list items.
//   static const EdgeInsets stockBadgeInner       = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
//   /// Padding for the date badge pill in transfer history items.
//   static const EdgeInsets dateBadgePadding      = EdgeInsets.symmetric(horizontal: 9, vertical: xs);
//   /// Padding for the Accept button on transfer history items.
//   static const EdgeInsets acceptBtnPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
//   /// Content padding for dropdowns and text fields in forms.
//   static const EdgeInsets dropdownContentPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
//   /// Padding of each data table row.
//   static const EdgeInsets tableRowPadding       = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   /// Padding of the table header row.
//   static const EdgeInsets tableHeaderPadding    = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   /// InfoRow (icon + label + value) padding inside info cards.
//   static const EdgeInsets infoRowPadding        = EdgeInsets.symmetric(horizontal: lg, vertical: md);
//   static const EdgeInsets noItemCardPadding     = EdgeInsets.all(lg);
//   /// Size of the hero header icon container.
//   static const double heroIconContainerSize     = 44.0;
//   // ── StockSubmitToManager ──────────────────────────
//   /// Outer list padding for the _LoadedBody scrollable ListView.
//   static const EdgeInsets submitListPadding     = EdgeInsets.fromLTRB(lg, 0, lg, xl);
//   /// Fixed top section padding (search bar + labels above the list).
//   static const EdgeInsets submitTopPadding      = EdgeInsets.fromLTRB(lg, lg, lg, 0);
//   /// Padding inside the search bar TextField content area.
//   static const EdgeInsets searchInputPadding    = EdgeInsets.symmetric(vertical: 14, horizontal: lg);
//   /// Padding for the stock table column-header row.
//   static const EdgeInsets stockTableHeaderPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
//   /// Padding for each row inside the stock data table.
//   static const EdgeInsets stockTableRowPadding  = EdgeInsets.symmetric(vertical: xs);
//   /// Padding around the delivery-man card header row (name / status).
//   static const EdgeInsets deliveryManCardHeaderPadding =
//   EdgeInsets.symmetric(horizontal: 14, vertical: md);
//   /// Bottom margin between delivery-man cards in the list.
//   static const double deliveryManCardBottomMargin = md;
//   /// Padding for the "No pending data" empty card inside a section.
//   static const EdgeInsets sectionEmptyCardPadding = EdgeInsets.all(20);
//   /// Padding for the global error / empty body containers.
//   static const EdgeInsets bodyStatePadding      = EdgeInsets.all(xxl);
//   // ── ItemReturn screen ─────────────────────────────
//   /// List padding for the main receipt list. Was: EdgeInsets.symmetric(horizontal:12, vertical:10)
//   static const EdgeInsets itemReturnListPadding      = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
//   /// Outer bottom margin of each receipt card. Was: EdgeInsets.only(bottom:8)
//   static const EdgeInsets itemReturnCardMargin       = EdgeInsets.only(bottom: 8);
//   /// Inner padding of the card header row. Was: EdgeInsets.fromLTRB(12,10,10,8)
//   static const EdgeInsets itemReturnCardHeader       = EdgeInsets.fromLTRB(12, 10, 10, 8);
//   /// Status badge padding. Was: EdgeInsets.symmetric(horizontal:8, vertical:3)
//   static const EdgeInsets itemReturnStatusBadgePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
//   /// Item row (inside expanded list) padding. Was: EdgeInsets.symmetric(horizontal:12, vertical:10)
//   static const EdgeInsets itemReturnItemRowPadding   = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
//   /// Stock chip padding on item row. Was: EdgeInsets.symmetric(horizontal:7, vertical:2)
//   static const EdgeInsets itemReturnStockChipPadding = EdgeInsets.symmetric(horizontal: 7, vertical: 2);
//   /// Footer row padding. Was: EdgeInsets.fromLTRB(8,2,8,8)
//   static const EdgeInsets itemReturnFooterPadding    = EdgeInsets.fromLTRB(8, 2, 8, 8);
//   /// Toggle button inner padding. Was: EdgeInsets.symmetric(horizontal:4, vertical:6)
//   static const EdgeInsets itemReturnTogglePadding    = EdgeInsets.symmetric(horizontal: 4, vertical: 6);
//   /// Action icon button (Out/Edit) inner padding. Was: EdgeInsets.all(8)
//   static const EdgeInsets itemReturnActionBtnPadding = EdgeInsets.all(8);
//   /// "Out" ElevatedButton padding. Was: EdgeInsets.symmetric(horizontal:24, vertical:12)
//   static const EdgeInsets itemReturnOutBtnPadding    = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
//   /// Dialog icon + item name header padding. Was: EdgeInsets.symmetric(horizontal:12, vertical:8)
//   static const EdgeInsets itemReturnDialogItemHeader = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
//
//   // ── SQC bottom sheet ──────────────────────────────
//   /// Drag handle margin. Was: EdgeInsets.only(top:10, bottom:14)
//   static const EdgeInsets sqcDragHandleMargin  = EdgeInsets.only(top: 10, bottom: 14);
//   /// Sheet header padding. Was: EdgeInsets.fromLTRB(20,0,20,12)
//   static const EdgeInsets sqcHeaderPadding     = EdgeInsets.fromLTRB(20, 0, 20, 12);
//   /// Vehicle list padding. Was: EdgeInsets.symmetric(horizontal:16, vertical:8)
//   static const EdgeInsets sqcListPadding       = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
//   /// Each vehicle row padding. Was: EdgeInsets.symmetric(horizontal:14, vertical:10)
//   static const EdgeInsets sqcVehicleRowPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 10);
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// Outer list padding for ItemReturnXMIListScreen. Was: fromLTRB(16,8,16,24)
//   static const EdgeInsets xmiListPadding        = EdgeInsets.fromLTRB(lg, sm, lg, xl);
//   /// Bottom gap between each XMI list card. Was: only(bottom:12)
//   static const EdgeInsets xmiCardGap            = EdgeInsets.only(bottom: md);
//   /// Card header inner padding. Was: fromLTRB(16,14,16,12)
//   static const EdgeInsets xmiCardHeaderPadding  = EdgeInsets.fromLTRB(lg, 14, lg, md);
//   /// Table column-header row padding. Was: fromLTRB(16,8,16,8)
//   static const EdgeInsets xmiTableHeaderPadding = EdgeInsets.fromLTRB(lg, sm, lg, sm);
//   /// Item row inner padding. Was: fromLTRB(16,10,16,10)
//   static const EdgeInsets xmiItemRowPadding     = EdgeInsets.fromLTRB(lg, 10, lg, 10);
//   /// Action button row padding. Was: fromLTRB(16,10,16,4)
//   static const EdgeInsets xmiActionRowPadding   = EdgeInsets.fromLTRB(lg, 10, lg, xs);
//   /// Expand/collapse toggle padding. Was: fromLTRB(16,10,16,12)
//   static const EdgeInsets xmiTogglePadding      = EdgeInsets.fromLTRB(lg, 10, lg, md);
//   /// Status badge padding. Was: symmetric(horizontal:10, vertical:5)
//   static const EdgeInsets xmiStatusBadgePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
//   /// Action button horizontal padding. Was: symmetric(horizontal:24)
//   static const EdgeInsets xmiActionBtnPadding   = EdgeInsets.symmetric(horizontal: xl);
//
//   // ── Display / Hero ──
//   static const TextStyle heroTitle = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     color: Colors.white,
//     letterSpacing: -0.5,
//     height: 1.2,
//   );
//
//   static const TextStyle heroSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: Colors.white70,
//     letterSpacing: 0.1,
//   );
//
//   // ── KPI Numbers (large, bold, prominent) ──
//   static const TextStyle kpiValueXL = TextStyle(
//     fontSize: 30,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.8,
//     height: 1.0,
//   );
//
//   static const TextStyle kpiValueLG = TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.6,
//     height: 1.1,
//   );
//
//   static const TextStyle kpiValueMD = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.4,
//     height: 1.1,
//   );
//
//   static const TextStyle heroKpiValue = TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w800,
//     color: Colors.white,
//     letterSpacing: -0.6,
//     height: 1.0,
//   );
//
//   // ── Labels & Body ──
//   static const TextStyle labelSM = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMuted,
//     letterSpacing: 0.6,
//   );
//
//   static const TextStyle labelMD = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMuted,
//     letterSpacing: 0.1,
//   );
//
//   static const TextStyle cardTitle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle cardSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textMuted,
//     height: 1.4,
//   );
//
//   static const TextStyle alertTitle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle alertValue = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     letterSpacing: -0.2,
//   );
//
//   static const TextStyle sectionHeaderq = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMid,
//     letterSpacing: 0.8,
//   );
//
//   static const TextStyle seeAll = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.blueLight,
//   );
//
//   static const TextStyle progressLabel = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle progressValue = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//   );
//
//   static const TextStyle navLabel = TextStyle(
//     fontSize: 10,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.2,
//     height: 1.0,
//   );
//
//   static const TextStyle miniLabel = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMuted,
//     letterSpacing: 0.5,
//   );
//
//   static const TextStyle miniValue = TextStyle(
//     fontSize: 28,
//     fontWeight: FontWeight.w800,
//     letterSpacing: -0.8,
//     height: 1.0,
//   );
//
//   static const TextStyle badgeText = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.1,
//   );
//
//   static const TextStyle dataRowLabel = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle dataRowValue = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//   );
//
//   static const TextStyle profitRowLabel = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle profitRowValue = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//   );
//
//   static const TextStyle profitHighlightValue = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.w800,
//     color: AppColors.green,
//     letterSpacing: -0.5,
//   );
//
//   // ── Sizes / dimensions ─────────────────────────────────
//   /// Height of the search bar container.
//   static const double searchBarHeight           = 48.0;
//   /// Size of the avatar circle / square in delivery-man cards.
//   static const double deliveryAvatarSize        = 40.0;
//   /// Size of error / empty state icon container.
//   static const double stateIconContainerSize    = 64.0;
// /// Section-label color dot width / height (already in AppSpacing.sectionDotSize below).
// // (re-uses sectionDotSize = 8.0 already defined further down)
//
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // BORDER RADIUS
// // ─────────────────────────────────────────────────────────────────────────────
//
// // class AppRadius {
// //   AppRadius._();
// //
// //   static const double xs   = 4.0;
// //   static const double sm   = 8.0;
// //   static const double md   = 12.0;
// //   static const double lg   = 14.0;
// //   static const double xl   = 18.0;
// //   static const double xxl  = 24.0;
// //   static const double full = 50.0;
// //
// //   // ── Pre-composed BorderRadius ─────────────────────
// //   static const BorderRadius card        = BorderRadius.all(Radius.circular(xl));
// //   static const BorderRadius chip        = BorderRadius.all(Radius.circular(lg));
// //   static const BorderRadius button      = BorderRadius.all(Radius.circular(full));
// //   static const BorderRadius dialog      = BorderRadius.all(Radius.circular(lg));
// //   static const BorderRadius input       = BorderRadius.all(Radius.circular(sm));
// //   static const BorderRadius cardTop     = BorderRadius.vertical(top: Radius.circular(xl));
// //   static const BorderRadius cardBottom  = BorderRadius.vertical(bottom: Radius.circular(xl));
// //
// //   // ── Delivery screen ───────────────────────────────
// //   /// Card radius used on delivery man list items and search field.
// //   static const BorderRadius deliveryCard   = BorderRadius.all(Radius.circular(16));
// //   /// Avatar / initial badge inside delivery cards.
// //   static const BorderRadius avatarBadge   = BorderRadius.all(Radius.circular(13));
// //   /// Search input field.
// //   static const BorderRadius searchInput   = BorderRadius.all(Radius.circular(lg));
// //   /// Hero header back-button container.
// //   static const BorderRadius heroBackBtn   = BorderRadius.all(Radius.circular(11));
// //   /// Empty-state icon container.
// //   static const BorderRadius emptyStateIcon = BorderRadius.all(Radius.circular(18));
// //   /// Hero count badge.
// //   static const BorderRadius heroBadge     = BorderRadius.all(Radius.circular(20));
// //
// //   // ── Stock / Transfer screens ──────────────────────
// //   /// Radius used on form cards and summary cards.
// //   static const BorderRadius formCard      = BorderRadius.all(Radius.circular(xl));
// //   /// Radius used on inline action buttons (Select Customer, Accept, etc.).
// //   static const BorderRadius inlineBtn     = BorderRadius.all(Radius.circular(20));
// //   /// Date badge pill on transfer history items.
// //   static const BorderRadius dateBadge     = BorderRadius.all(Radius.circular(20));
// //   /// Checkbox chip border.
// //   static const BorderRadius checkboxChip  = BorderRadius.all(Radius.circular(sm));
// //   /// Stock count chip inside summary card.
// //   static const BorderRadius stockChip     = BorderRadius.all(Radius.circular(md));
// //   /// Warning / amber panel.
// //   static const BorderRadius warningPanel  = BorderRadius.all(Radius.circular(md));
// //   /// Table top-rounded header.
// //   static const BorderRadius tableTop      = BorderRadius.vertical(top: Radius.circular(lg));
// //   /// Table bottom-rounded body.
// //   static const BorderRadius tableBottom   = BorderRadius.vertical(bottom: Radius.circular(lg));
// //   /// Icon badge / icon box inside info/vehicle rows.
// //   static const BorderRadius iconBadge     = BorderRadius.all(Radius.circular(10));
// //   /// ElevatedButton / OutlinedButton on forms.
// //   static const BorderRadius formButton    = BorderRadius.all(Radius.circular(lg));
// //   /// AppBar TextButton action.
// //   static const BorderRadius appBarBtn     = BorderRadius.all(Radius.circular(sm));
// //   /// Edit/delete action icon button.
// //   static const BorderRadius actionIcon    = BorderRadius.all(Radius.circular(6));
// //   /// Dropdown form field border.
// //   static const BorderRadius formDropdown  = BorderRadius.all(Radius.circular(md));
// // }
//
// class AppRadius {
//   AppRadius._();
//
//   static const double xxs  =  4.0;
//   static const double xs   =  6.0;
//   static const double sm   =  8.0;
//   static const double md   = 10.0;
//   static const double lg   = 12.0;
//   static const double xl   = 16.0;
//   static const double xxl  = 20.0;
//   static const double xxxl = 24.0;
//   static const double full = 100.0;
//
//
//   // ── Pre-composed BorderRadius ─────────────────────
//   static const BorderRadius card        = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius cardTop     = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   static const BorderRadius chip        = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius stockChip   = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius input       = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius button      = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius inlineBtn   = BorderRadius.all(Radius.circular(xs));
//   static const BorderRadius dialog      = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius formCard    = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius formDropdown = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius deliveryCard = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius avatarBadge  = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius heroBackBtn  = BorderRadius.all(Radius.circular(md));
//   static const BorderRadius heroBadge    = BorderRadius.all(Radius.circular(full));
//   static const BorderRadius emptyStateIcon = BorderRadius.all(Radius.circular(18));
//   static const BorderRadius searchInput   = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius warningPanel  = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius tableTop      = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   static const BorderRadius tableBottom   = BorderRadius.only(
//     bottomLeft: Radius.circular(xl), bottomRight: Radius.circular(xl),
//   );
//   static const BorderRadius actionIcon    = BorderRadius.all(Radius.circular(xs));
//   static const BorderRadius iconBadge     = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius dateBadge     = BorderRadius.all(Radius.circular(full));
//
//   // ── StockSubmitToManager ─────────────────────────
//   /// Search bar container border radius.
//   static const BorderRadius searchBar           = BorderRadius.all(Radius.circular(14));
//   /// Delivery-man card border radius.
//   static const BorderRadius deliveryManCard     = BorderRadius.all(Radius.circular(xl));
//   /// Avatar badge inside delivery-man card header.
//   static const BorderRadius deliveryManAvatar   = BorderRadius.all(Radius.circular(11));
//   /// Status pill badge border radius (circular).
//   static const BorderRadius statusPill          = BorderRadius.all(Radius.circular(full));
//   /// Error / empty state icon container border radius.
//   static const BorderRadius stateIconContainer  = BorderRadius.all(Radius.circular(18));
//   /// Total-sale card top corners.
//   static const BorderRadius totalSaleCardTop    = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   /// Hero header icon container border radius.
//   static const BorderRadius heroIconContainer   = BorderRadius.all(Radius.circular(13));
//   /// Section-label color dot border radius.
//   static const BorderRadius sectionDot          = BorderRadius.all(Radius.circular(xxs));
// //   /// AppBar TextButton action.
//   static const BorderRadius appBarBtn     = BorderRadius.all(Radius.circular(sm));
// //   /// Checkbox chip border.
//   static const BorderRadius checkboxChip  = BorderRadius.all(Radius.circular(sm));
// //   /// ElevatedButton / OutlinedButton on forms.
//   static const BorderRadius formButton    = BorderRadius.all(Radius.circular(lg));
//
//
//   // ── ItemReturn ────────────────────────────────────
//   /// Receipt card outer container. Was: BorderRadius.circular(14)
//   static const BorderRadius itemReturnCard        = BorderRadius.all(Radius.circular(14));
//   /// Bottom sheet top. Was: BorderRadius.vertical(top: Radius.circular(20))
//   static const BorderRadius itemReturnSheet       = BorderRadius.only(
//     topLeft: Radius.circular(xxl), topRight: Radius.circular(xxl),
//   );
//   /// Vehicle card in SQC list. Was: BorderRadius.circular(12)
//   static const BorderRadius itemReturnVehicleCard = BorderRadius.all(Radius.circular(lg));
//   /// Stock chip on each item row. Was: BorderRadius.circular(6)
//   static const BorderRadius itemReturnStockChip   = BorderRadius.all(Radius.circular(xs));
//   /// AlertDialog (main). Was: BorderRadius.circular(20)
//   static const BorderRadius itemReturnDialog      = BorderRadius.all(Radius.circular(xxl));
//   /// Inner AlertDialog (stock exceeded). Was: BorderRadius.circular(16)
//   static const BorderRadius itemReturnInnerDialog = BorderRadius.all(Radius.circular(xl));
//   /// Form fields inside dialog. Was: BorderRadius.circular(12)
//   static const BorderRadius itemReturnDialogField = BorderRadius.all(Radius.circular(lg));
//   /// "Out" ElevatedButton. Was: BorderRadius.circular(12)
//   static const BorderRadius itemReturnOutBtn      = BorderRadius.all(Radius.circular(lg));
//   /// Empty-state icon box. Was: BorderRadius.circular(16)
//   static const BorderRadius itemReturnEmptyIcon   = BorderRadius.all(Radius.circular(xl));
//
//   // ── SQC bottom sheet sub-elements ────────────────
//   /// Drag handle pill. Was: BorderRadius.circular(2)
//   static const BorderRadius sqcDragHandle = BorderRadius.all(Radius.circular(xxs));
//   /// Title dot. Was: BorderRadius.circular(2)
//   static const BorderRadius sqcDot        = BorderRadius.all(Radius.circular(xxs));
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// XMI list card outer container. Was: BorderRadius.circular(18)
//   static const BorderRadius xmiCard             = BorderRadius.all(Radius.circular(18));
//   /// Vehicle icon badge in card header. Was: BorderRadius.circular(13)
//   static const BorderRadius xmiVehicleIconBadge = BorderRadius.all(Radius.circular(13));
//   /// Status badge (Received / Pending). Was: BorderRadius.circular(20)
//   static const BorderRadius xmiStatusBadge      = BorderRadius.all(Radius.circular(xxl));
//   /// Expand toggle bottom border. Was: BorderRadius.vertical(bottom: Radius.circular(18))
//   static const BorderRadius xmiToggleBottom     = BorderRadius.only(
//     bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18),
//   );
//   /// Dialog shape. Was: BorderRadius.circular(18)
//   static const BorderRadius xmiDialog           = BorderRadius.all(Radius.circular(18));
//   /// Action button pill shape. Was: BorderRadius.circular(50)
//   static const BorderRadius xmiActionBtn        = BorderRadius.all(Radius.circular(full));
// }
//
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SHADOWS
// // ─────────────────────────────────────────────────────────────────────────────
//
// // class AppShadows {
// //   AppShadows._();
// //
// //   static const List<BoxShadow> card = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 12,
// //       offset: Offset(0, 2),
// //     ),
// //   ];
// //
// //   static const List<BoxShadow> chip = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 8,
// //       offset: Offset(0, 2),
// //     ),
// //   ];
// //
// //   /// Slightly lifted shadow for table body container.
// //   static const List<BoxShadow> tableBody = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 12,
// //       offset: Offset(0, 4),
// //     ),
// //   ];
// //
// //   /// Subtle shadow for stock history list items.
// //   static const List<BoxShadow> listItem = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 10,
// //       offset: Offset(0, 2),
// //     ),
// //   ];
// //
// //   static const List<BoxShadow> none = [];
// // }
//
// class AppShadows {
//   AppShadows._();
//
//   static const List<BoxShadow> card = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 12,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   static const List<BoxShadow> chip = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 6,
//       offset: Offset(0, 1),
//     ),
//   ];
//
//   static const List<BoxShadow> listItem = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 6,
//       offset: Offset(0, 1),
//     ),
//   ];
//
//   static const List<BoxShadow> tableBody = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 8,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   // ── StockSubmitToManager ──────────────────────────
//   /// Shadow used on search bar, delivery-man cards, and total-sale card.
//   static const List<BoxShadow> submitCard = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 10,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   /// Slightly larger shadow for delivery-man and total-sale cards.
//   static const List<BoxShadow> submitCardLg = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 12,
//       offset: Offset(0, 2),
//     ),
//   ];
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SIZES  (icon sizes, avatar dimensions, fixed heights, stroke widths)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppSizes {
//   AppSizes._();
//
//   // ── Delivery men screen ───────────────────────────
//   static const double deliveryAvatarSize  = 44.0;
//   static const double heroBackBtnSize     = 38.0;
//   static const double emptyStateIconSize  = 64.0;
//   static const double heroBackIconSize    = 16.0;
//   static const double emptyStateIconPx    = 30.0;
//   static const double chevronSize         = 22.0;
//   static const double searchIconSize      = 20.0;
//   static const double loadingStrokeWidth  = 2.5;
//   static const double iconMd           =  24.0;
//
//   static const double iconXss           =  14.0;
//   static const double iconXs           =  16.0;
//   static const double iconSm           =  20.0;
//   static const double iconLg           =  30.0;
//
//   // ── Stock / info-row icon badge ───────────────────
//   /// Square size of icon badge boxes (vehicle, calendar, person rows).
//   static const double infoIconBadgeSize   = 36.0;
//   /// Width of the left colored border on delivery-man cards.
//   static const double deliveryCardAccentBorderWidth = 4.0;
//   /// Icon size inside an info-row icon badge.
//   static const double infoIconSize        = 18.0;
//   /// Square size of icon badge inside stock summary cards.
//   static const double stockCardIconSize   = 40.0;
//   /// Icon size inside stock summary cards.
//   static const double stockCardIcon       = 20.0;
//   /// Edit/delete action icon inside table rows.
//   static const double tableActionIcon     = 14.0;
//   /// Compact loading spinner size (inside FutureBuilder awaiting state).
//   static const double miniSpinnerSize     = 24.0;
//   /// Stroke width for the mini loading spinner.
//   static const double miniSpinnerStroke   = 2.0;
//   /// Minimum height of primary ElevatedButton on forms.
//   static const double formBtnHeight       = 50.0;
//   /// Minimum height of the submit ElevatedButton (stock transfer).
//   static const double submitBtnHeight     = 52.0;
//   /// Section label dot width/height.
//   static const double sectionDotSize      = 8.0;
//   /// Stock history list fixed container height.
//   static const double historyListHeight   = 200.0;
//   /// Table header checkbox icon size.
//   static const double checkboxIconSize    = 16.0;
//
//   // ── StockSubmitToManager ──────────────────────────
//   /// Width of the column divider inside the stock table.
//   static const double stockTableDividerWidth  = 1.0;
//   /// Height of the column divider in the table header row.
//   static const double stockTableDividerHeightHeader = 8.0;
//   /// Height of the column divider in table data rows.
//   static const double stockTableDividerHeightRow    = 16.0;
//   /// Horizontal margin of column dividers.
//   static const double stockTableDividerHMargin      = 2.0;
//   /// Size of the more-vert popup icon.
//   static const double popupMenuIconSize       = 22.0;
//
//   // ── ItemReturn screen ─────────────────────────────
//   /// Card left accent border width. Was: 3
//   static const double itemReturnCardAccentBorder  = 3.0;
//   /// Card shadow blur radius. Was: 8
//   static const double itemReturnCardShadowBlur    = 8.0;
//   /// Vehicle icon box size (card header). Was: 36×36
//   static const double itemReturnVehicleIconBox    = 36.0;
//   /// Vehicle icon size (card header). Was: 18
//   static const double itemReturnVehicleIconSize   = 18.0;
//   /// Action icon button size (Out / Edit). Was: 18
//   static const double itemReturnActionIcon        = 18.0;
//   /// Toggle arrow icon size. Was: 18
//   static const double itemReturnToggleIcon        = 18.0;
//   /// Empty-state icon box. Was: 56×56
//   static const double itemReturnEmptyIconBox      = 56.0;
//   /// Empty-state icon pixel size. Was: 28
//   static const double itemReturnEmptyIconPx       = 28.0;
//   /// Dialog title icon box. Was: 36×36
//   static const double itemReturnDialogIconBox     = 36.0;
//   /// Dialog title icon size. Was: 20
//   static const double itemReturnDialogIconSize    = 20.0;
//
//   // ── SQC bottom sheet ──────────────────────────────
//   /// Drag handle width. Was: 36
//   static const double sqcDragHandleWidth  = 36.0;
//   /// Drag handle height. Was: 4
//   static const double sqcDragHandleHeight = 4.0;
//   /// Title accent dot size. Was: 7×7
//   static const double sqcDotSize         = 7.0;
//   /// Vehicle icon box in SQC list. Was: 34×34
//   static const double sqcVehicleIconBox  = 34.0;
//   /// Vehicle icon size in SQC list. Was: 17
//   static const double sqcVehicleIconSize = 17.0;
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// Vehicle icon badge container size. Was: 44×44
//   static const double xmiVehicleIconBox  = 44.0;
//   /// Vehicle icon pixel size inside badge. Was: 22
//   static const double xmiVehicleIconPx   = 22.0;
//   /// Empty-state icon box size. Was: 72×72
//   static const double xmiEmptyIconBox    = 72.0;
//   /// Empty-state icon pixel size. Was: 34
//   static const double xmiEmptyIconPx     = 34.0;
//   /// Toggle icon size. Was: 20
//   static const double xmiToggleIconSize  = 20.0;
//   /// Action button height. Was: 36
//   static const double xmiActionBtnHeight = 36.0;
//   /// Fixed width of each quantity column cell. Was: 62
//   static const double xmiQtyColWidth     = 62.0;
//   /// Loading spinner stroke width. Was: 3
//   static const double xmiLoadingStroke   = 3.0;
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // DECORATIONS  (reusable BoxDecoration bundles)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppDecorations {
//   AppDecorations._();
//
//   // ── Generic card ─────────────────────────────────
//   static BoxDecoration card({
//     Color? color,
//     BorderRadius? borderRadius,
//     List<BoxShadow>? shadows,
//   }) =>
//       BoxDecoration(
//         color: color ?? AppColors.surface,
//         borderRadius: borderRadius ?? AppRadius.card,
//         boxShadow: shadows ?? AppShadows.card,
//       );
//
//   // ── Card header (top rounded, light bg) ──────────
//   static const BoxDecoration cardHeader = BoxDecoration(
//     color: AppColors.surfaceMuted,
//     borderRadius: AppRadius.cardTop,
//   );
//
//   // ── Stock chip (top accent bar) ──────────────────
//   static BoxDecoration stockChipAccent({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.chip,
//     border: Border(top: BorderSide(color: accentColor, width: 3)),
//     boxShadow: AppShadows.chip,
//   );
//
//   // ── Dropdown pill (compact) ───────────────────────
//   static const BoxDecoration dropdownPill = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
//     border: Border.fromBorderSide(
//       BorderSide(color: AppColors.primaryXXLight),
//     ),
//   );
//
//   // ── Transfer / action button ──────────────────────
//   static BoxDecoration transferButton({required bool disabled}) => BoxDecoration(
//     color: disabled ? const Color(0xFFF3F4F6) : AppColors.redXLight,
//     borderRadius: AppRadius.button,
//     border: Border.all(
//       color: disabled ? const Color(0xFFD1D5DB) : AppColors.red.withOpacity(0.3),
//     ),
//   );
//
//   // ── Badge / status pill ───────────────────────────
//   static BoxDecoration statusBadge({required bool isPositive}) => BoxDecoration(
//     color: isPositive ? AppColors.greenXLight : AppColors.redXLight,
//     borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
//   );
//
//   // ── Modal bottom sheet drag handle ───────────────
//   static BoxDecoration dragHandle = BoxDecoration(
//     color: AppColors.primaryXXLight,
//     borderRadius: const BorderRadius.all(Radius.circular(10)),
//   );
//
//   // ── FAB ──────────────────────────────────────────
//   static const BoxDecoration fab = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: BorderRadius.all(Radius.circular(AppRadius.full)),
//   );
//
//   // ── Delivery man list card ────────────────────────
//   static const BoxDecoration deliveryCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryCard,
//     boxShadow: AppShadows.card,
//   );
//
//   // ── Delivery man avatar badge ─────────────────────
//   static const BoxDecoration deliveryAvatar = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.avatarBadge,
//   );
//
//   // ── Hero header back button ───────────────────────
//   static BoxDecoration heroBackButton = BoxDecoration(
//     color: Colors.white.withOpacity(0.15),
//     borderRadius: AppRadius.heroBackBtn,
//     border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
//   );
//
//   // ── Hero header count badge ───────────────────────
//   static BoxDecoration heroBadge = BoxDecoration(
//     color: Colors.white.withOpacity(0.15),
//     borderRadius: AppRadius.heroBadge,
//     border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
//   );
//
//   // ── Empty-state icon container ────────────────────
//   static const BoxDecoration emptyStateIcon = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.emptyStateIcon,
//   );
//
//   // ── Search field borders ──────────────────────────
//   static OutlineInputBorder searchBorderNone = OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide.none,
//   );
//   static OutlineInputBorder searchBorderEnabled = const OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide(color: AppColors.border, width: 1),
//   );
//   static OutlineInputBorder searchBorderFocused = const OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
//   );
//
//   // ── Stock / Transfer screens ──────────────────────
//
//   /// White rounded-corner card used by form cards and summary cards.
//   static const BoxDecoration formCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.formCard,
//     boxShadow: AppShadows.card,
//   );
//
//   /// Stock history list item (white card, lighter shadow).
//   static const BoxDecoration stockListItem = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryCard,
//     boxShadow: AppShadows.listItem,
//   );
//
//   /// Amber warning / imbalance assignment panel.
//   static const BoxDecoration warningPanel = BoxDecoration(
//     color: AppColors.warningBg,
//     borderRadius: AppRadius.warningPanel,
//     // Border added dynamically because Border.all isn't const with runtime colors
//   );
//
//   /// Table header bar — primary blue, top-rounded only.
//   static const BoxDecoration tableHeader = BoxDecoration(
//     color: AppColors.primary,
//     borderRadius: AppRadius.tableTop,
//   );
//
//   /// Table body — white, bottom-rounded only.
//   static const BoxDecoration tableBody = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.tableBottom,
//     boxShadow: AppShadows.tableBody,
//   );
//
//   /// Edit action icon button — primary-tinted background.
//   static const BoxDecoration editActionBtn = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.actionIcon,
//   );
//
//   /// Delete action icon button — red-tinted background.
//   static const BoxDecoration deleteActionBtn = BoxDecoration(
//     color: AppColors.redXLight,
//     borderRadius: AppRadius.actionIcon,
//   );
//
//   /// Icon badge box used inside info rows (vehicle, calendar, person).
//   static const BoxDecoration infoIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.iconBadge,
//   );
//
//   /// Icon badge box inside stock summary card header.
//   static const BoxDecoration stockCardIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.stockChip, // circular(12)
//   );
//     static BoxDecoration stockChip({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.chip,
//     border: Border(top: BorderSide(color: accentColor, width: 3)),
//     boxShadow: AppShadows.chip,
//   );
//
//   /// Accept button on transfer history items.
//   static const BoxDecoration acceptBtn = BoxDecoration(
//     color: AppColors.primary,
//     borderRadius: AppRadius.inlineBtn,
//   );
//
//   /// Date badge pill on transfer history items.
//   static const BoxDecoration dateBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.dateBadge,
//   );
//
//   // ── Standard form field borders (used on dropdowns + textfields in forms) ──
//   static OutlineInputBorder formBorderEnabled = const OutlineInputBorder(
//     borderRadius: AppRadius.formDropdown,
//     borderSide: BorderSide(color: AppColors.border),
//   );
//   static OutlineInputBorder formBorderFocused = const OutlineInputBorder(
//     borderRadius: AppRadius.formDropdown,
//     borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
//   );
//
//
//
//   /// Search bar container decoration.
//   static final BoxDecoration searchBar = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.searchBar,
//     boxShadow: AppShadows.submitCard,
//   );
//
//   /// Delivery-man card outer container decoration (border applied dynamically
//   /// for the left status-color accent; boxShadow is constant).
//   static BoxDecoration deliveryManCard({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     border: Border(
//       left: BorderSide(color: accentColor, width: AppSizes.deliveryCardAccentBorderWidth),
//     ),
//     boxShadow: AppShadows.submitCardLg,
//   );
//
//   /// Avatar badge inside delivery-man card (background = status bg color,
//   /// applied dynamically; shape is constant).
//   static BoxDecoration deliveryManAvatar({required Color bgColor}) => BoxDecoration(
//     color: bgColor,
//     borderRadius: AppRadius.deliveryManAvatar,
//   );
//
//   /// Status pill badge decoration (background = status bg color, applied dynamically).
//   static BoxDecoration statusPill({required Color bgColor}) => BoxDecoration(
//     color: bgColor,
//     borderRadius: AppRadius.statusPill,
//   );
//
//   /// Error state icon container.
//   static const BoxDecoration errorStateIcon = BoxDecoration(
//     color: AppColors.redXLight,
//     borderRadius: AppRadius.stateIconContainer,
//   );
//
//   /// Empty state icon container.
//   static const BoxDecoration emptyStateIconBlue = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.stateIconContainer,
//   );
//
//   /// Section-empty-card (e.g. "No summary data yet").
//   static const BoxDecoration sectionEmptyCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     boxShadow: AppShadows.submitCard,
//   );
//
//   /// Total-sale card container.
//   static const BoxDecoration totalSaleCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     boxShadow: AppShadows.submitCardLg,
//   );
//
//   /// Total-sale card table header (blue-tinted, top-rounded).
//   static const BoxDecoration totalSaleCardHeader = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.totalSaleCardTop,
//   );
//
//   /// Hero header icon container (used in _HeroHeader).
//   static BoxDecoration heroHeaderIcon = BoxDecoration(
//     color: Colors.white.withOpacity(0.16),
//     borderRadius: AppRadius.heroIconContainer,
//     border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
//   );
//
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// XMI list card outer container.
//   static const BoxDecoration xmiCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.xmiCard,
//     boxShadow: AppShadows.card,
//   );
//
//   /// Vehicle icon badge inside XMI card header.
//   static const BoxDecoration xmiVehicleIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.xmiVehicleIconBadge,
//   );
//
//   /// Column header row background in the XMI item table.
//   static const BoxDecoration xmiTableHeaderRow = BoxDecoration(
//     color: AppColors.xmiTableHeaderBg,
//   );
//
//   /// Divider line inside XMI item table rows.
//   static Border xmiRowDivider = const Border(
//     bottom: BorderSide(color: AppColors.divider, width: 1),
//   );
// }


// import 'package:flutter/material.dart';
// import 'app_colors.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SPACING
// // ─────────────────────────────────────────────────────────────────────────────
//
// /// 4-pt grid spacing constants.
// /// Usage: SizedBox(height: AppSpacing.md)
// ///        Padding(padding: AppSpacing.cardPadding)
// class AppSpacing {
//   AppSpacing._();
//
//   static const double xxs  = 2.0;
//   static const double xs   = 4.0;
//   static const double sm   = 8.0;
//   static const double md   = 12.0;
//   static const double lg   = 16.0;
//   static const double xl   = 24.0;
//   static const double xxl  = 32.0;
//   static const double xxxl = 48.0;
//
//   // ── Pre-composed EdgeInsets ───────────────────────
//   static const EdgeInsets cardPadding      = EdgeInsets.all(lg);
//   static const EdgeInsets pagePadding      = EdgeInsets.fromLTRB(lg, 0, lg, xxl);
//   static const EdgeInsets chipPadding      = EdgeInsets.symmetric(horizontal: md, vertical: xs);
//   static const EdgeInsets rowPadding       = EdgeInsets.symmetric(horizontal: lg, vertical: sm + xs);
//   static const EdgeInsets sectionHeader    = EdgeInsets.fromLTRB(0, xxl, 0, sm);
//   static const EdgeInsets stockChip        = EdgeInsets.symmetric(vertical: 14, horizontal: 10);
//   static const EdgeInsets buttonPadding    = EdgeInsets.symmetric(horizontal: 14, vertical: 6);
//
//   // ── Delivery men list screen ──────────────────────
//   static const EdgeInsets searchBarPadding = EdgeInsets.fromLTRB(lg, md, lg, md);
//   static const EdgeInsets listPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
//   static const EdgeInsets deliveryCardPadding = EdgeInsets.symmetric(horizontal: lg, vertical: 14);
//   static const EdgeInsets heroHeaderPadding = EdgeInsets.fromLTRB(20, 16, 20, 20);
//   static const EdgeInsets heroBadgePadding = EdgeInsets.symmetric(horizontal: md, vertical: 6);
//
//   // ── Stock / Transfer screens ──────────────────────
//   static const EdgeInsets formBodyPadding       = EdgeInsets.fromLTRB(16, 16, 16, 32);
//   static const EdgeInsets formCardPadding       = EdgeInsets.all(18);
//   static const EdgeInsets stockItemPadding      = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
//   static const EdgeInsets warningPanelPadding   = EdgeInsets.all(md);
//   static const EdgeInsets inlineActionPadding   = EdgeInsets.symmetric(horizontal: 10, vertical: 6);
//   static const EdgeInsets appBarActionPadding   = EdgeInsets.symmetric(horizontal: lg, vertical: 10);
//   static const EdgeInsets stockChipInner        = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   static const EdgeInsets stockBadgeInner       = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
//   static const EdgeInsets dateBadgePadding      = EdgeInsets.symmetric(horizontal: 9, vertical: xs);
//   static const EdgeInsets acceptBtnPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
//   static const EdgeInsets dropdownContentPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
//   static const EdgeInsets tableRowPadding       = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   static const EdgeInsets tableHeaderPadding    = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   static const EdgeInsets infoRowPadding        = EdgeInsets.symmetric(horizontal: lg, vertical: md);
//   static const EdgeInsets noItemCardPadding     = EdgeInsets.all(lg);
//   static const double heroIconContainerSize     = 44.0;
//
//   // ── StockSubmitToManager ──────────────────────────
//   static const EdgeInsets submitListPadding     = EdgeInsets.fromLTRB(lg, 0, lg, xl);
//   static const EdgeInsets submitTopPadding      = EdgeInsets.fromLTRB(lg, lg, lg, 0);
//   static const EdgeInsets searchInputPadding    = EdgeInsets.symmetric(vertical: 14, horizontal: lg);
//   static const EdgeInsets stockTableHeaderPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
//   static const EdgeInsets stockTableRowPadding  = EdgeInsets.symmetric(vertical: xs);
//   static const EdgeInsets deliveryManCardHeaderPadding =
//   EdgeInsets.symmetric(horizontal: 14, vertical: md);
//   static const double deliveryManCardBottomMargin = md;
//   static const EdgeInsets sectionEmptyCardPadding = EdgeInsets.all(20);
//   static const EdgeInsets bodyStatePadding      = EdgeInsets.all(xxl);
//
//   // ── ItemReturn screen ─────────────────────────────
//   static const EdgeInsets itemReturnListPadding      = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
//   static const EdgeInsets itemReturnCardMargin       = EdgeInsets.only(bottom: 8);
//   static const EdgeInsets itemReturnCardHeader       = EdgeInsets.fromLTRB(12, 10, 10, 8);
//   static const EdgeInsets itemReturnStatusBadgePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
//   static const EdgeInsets itemReturnItemRowPadding   = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
//   static const EdgeInsets itemReturnStockChipPadding = EdgeInsets.symmetric(horizontal: 7, vertical: 2);
//   static const EdgeInsets itemReturnFooterPadding    = EdgeInsets.fromLTRB(8, 2, 8, 8);
//   static const EdgeInsets itemReturnTogglePadding    = EdgeInsets.symmetric(horizontal: 4, vertical: 6);
//   static const EdgeInsets itemReturnActionBtnPadding = EdgeInsets.all(8);
//   static const EdgeInsets itemReturnOutBtnPadding    = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
//   static const EdgeInsets itemReturnDialogItemHeader = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
//
//   // ── SQC bottom sheet ──────────────────────────────
//   static const EdgeInsets sqcDragHandleMargin  = EdgeInsets.only(top: 10, bottom: 14);
//   static const EdgeInsets sqcHeaderPadding     = EdgeInsets.fromLTRB(20, 0, 20, 12);
//   static const EdgeInsets sqcListPadding       = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
//   static const EdgeInsets sqcVehicleRowPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 10);
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// Outer list padding for ItemReturnXMIListScreen. Was: fromLTRB(16,8,16,24)
//   static const EdgeInsets xmiListPadding        = EdgeInsets.fromLTRB(lg, sm, lg, xl);
//   /// Bottom gap between each XMI list card. Was: only(bottom:12)
//   static const EdgeInsets xmiCardGap            = EdgeInsets.only(bottom: md);
//   /// Card header inner padding. Was: fromLTRB(16,14,16,12)
//   static const EdgeInsets xmiCardHeaderPadding  = EdgeInsets.fromLTRB(lg, 14, lg, md);
//   /// Table column-header row padding. Was: fromLTRB(16,8,16,8)
//   static const EdgeInsets xmiTableHeaderPadding = EdgeInsets.fromLTRB(lg, sm, lg, sm);
//   /// Item row inner padding. Was: fromLTRB(16,10,16,10)
//   static const EdgeInsets xmiItemRowPadding     = EdgeInsets.fromLTRB(lg, 10, lg, 10);
//   /// Action button row padding. Was: fromLTRB(16,10,16,4)
//   static const EdgeInsets xmiActionRowPadding   = EdgeInsets.fromLTRB(lg, 10, lg, xs);
//   /// Expand/collapse toggle padding. Was: fromLTRB(16,10,16,12)
//   static const EdgeInsets xmiTogglePadding      = EdgeInsets.fromLTRB(lg, 10, lg, md);
//   /// Status badge padding. Was: symmetric(horizontal:10, vertical:5)
//   static const EdgeInsets xmiStatusBadgePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
//   /// Action button horizontal padding. Was: symmetric(horizontal:24)
//   static const EdgeInsets xmiActionBtnPadding   = EdgeInsets.symmetric(horizontal: xl);
//
//   // ── MarkDefectiveItem screens ─────────────────────
//   /// Outer body scroll padding (page sides + bottom). Was: fromLTRB(16, 0, 16, 24)
//   static const EdgeInsets markDefectivePagePadding = EdgeInsets.fromLTRB(lg, 0, lg, xl);
//   /// Vertical padding for the Submit ElevatedButton. Was: symmetric(vertical: 15)
//   static const EdgeInsets markDefectiveSubmitBtn   = EdgeInsets.symmetric(vertical: 15);
//   /// Gap between form fields inside the entry card. Was: SizedBox(height: 14)
//   static const double     markDefectiveFieldGap    = 14.0;
//
//   // ── Display / Hero ──
//   static const TextStyle heroTitle = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     color: Colors.white,
//     letterSpacing: -0.5,
//     height: 1.2,
//   );
//
//   static const TextStyle heroSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: Colors.white70,
//     letterSpacing: 0.1,
//   );
//
//   // ── KPI Numbers (large, bold, prominent) ──
//   static const TextStyle kpiValueXL = TextStyle(
//     fontSize: 30,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.8,
//     height: 1.0,
//   );
//
//   static const TextStyle kpiValueLG = TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.6,
//     height: 1.1,
//   );
//
//   static const TextStyle kpiValueMD = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.4,
//     height: 1.1,
//   );
//
//   // ── Labels & Body ──
//   static const TextStyle labelSM = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMuted,
//     letterSpacing: 0.6,
//   );
//
//   static const TextStyle labelMD = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMuted,
//     letterSpacing: 0.1,
//   );
//
//   static const TextStyle cardTitle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle cardSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textMuted,
//     height: 1.4,
//   );
//
//   static const TextStyle alertTitle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle alertValue = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     letterSpacing: -0.2,
//   );
//
//   static const TextStyle sectionHeaderq = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMid,
//     letterSpacing: 0.8,
//   );
//
//   static const TextStyle seeAll = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.blueLight,
//   );
//
//   static const TextStyle progressLabel = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle progressValue = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//   );
//
//   static const TextStyle navLabel = TextStyle(
//     fontSize: 10,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.2,
//     height: 1.0,
//   );
//
//   static const TextStyle miniLabel = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMuted,
//     letterSpacing: 0.5,
//   );
//
//   static const TextStyle miniValue = TextStyle(
//     fontSize: 28,
//     fontWeight: FontWeight.w800,
//     letterSpacing: -0.8,
//     height: 1.0,
//   );
//
//   static const TextStyle badgeText = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.1,
//   );
//
//   static const TextStyle dataRowLabel = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle dataRowValue = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//   );
//
//   static const TextStyle profitRowLabel = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle profitRowValue = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//   );
//
//   static const TextStyle profitHighlightValue = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.w800,
//     color: AppColors.green,
//     letterSpacing: -0.5,
//   );
//
//   // ── Sizes / dimensions ─────────────────────────────────
//   static const double searchBarHeight           = 48.0;
//   static const double deliveryAvatarSize        = 40.0;
//   static const double stateIconContainerSize    = 64.0;
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // BORDER RADIUS
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppRadius {
//   AppRadius._();
//
//   static const double xxs  =  4.0;
//   static const double xs   =  6.0;
//   static const double sm   =  8.0;
//   static const double md   = 10.0;
//   static const double lg   = 12.0;
//   static const double xl   = 16.0;
//   static const double xxl  = 20.0;
//   static const double xxxl = 24.0;
//   static const double full = 100.0;
//
//   // ── Pre-composed BorderRadius ─────────────────────
//   static const BorderRadius card        = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius cardTop     = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   static const BorderRadius chip        = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius stockChip   = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius input       = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius button      = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius inlineBtn   = BorderRadius.all(Radius.circular(xs));
//   static const BorderRadius dialog      = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius formCard    = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius formDropdown = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius deliveryCard = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius avatarBadge  = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius heroBackBtn  = BorderRadius.all(Radius.circular(md));
//   static const BorderRadius heroBadge    = BorderRadius.all(Radius.circular(full));
//   static const BorderRadius emptyStateIcon = BorderRadius.all(Radius.circular(18));
//   static const BorderRadius searchInput   = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius warningPanel  = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius tableTop      = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   static const BorderRadius tableBottom   = BorderRadius.only(
//     bottomLeft: Radius.circular(xl), bottomRight: Radius.circular(xl),
//   );
//   static const BorderRadius actionIcon    = BorderRadius.all(Radius.circular(xs));
//   static const BorderRadius iconBadge     = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius dateBadge     = BorderRadius.all(Radius.circular(full));
//
//   // ── StockSubmitToManager ─────────────────────────
//   static const BorderRadius searchBar           = BorderRadius.all(Radius.circular(14));
//   static const BorderRadius deliveryManCard     = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius deliveryManAvatar   = BorderRadius.all(Radius.circular(11));
//   static const BorderRadius statusPill          = BorderRadius.all(Radius.circular(full));
//   static const BorderRadius stateIconContainer  = BorderRadius.all(Radius.circular(18));
//   static const BorderRadius totalSaleCardTop    = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   static const BorderRadius heroIconContainer   = BorderRadius.all(Radius.circular(13));
//   static const BorderRadius sectionDot          = BorderRadius.all(Radius.circular(xxs));
//   static const BorderRadius appBarBtn     = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius checkboxChip  = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius formButton    = BorderRadius.all(Radius.circular(lg));
//
//   // ── ItemReturn ────────────────────────────────────
//   static const BorderRadius itemReturnCard        = BorderRadius.all(Radius.circular(14));
//   static const BorderRadius itemReturnSheet       = BorderRadius.only(
//     topLeft: Radius.circular(xxl), topRight: Radius.circular(xxl),
//   );
//   static const BorderRadius itemReturnVehicleCard = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius itemReturnStockChip   = BorderRadius.all(Radius.circular(xs));
//   static const BorderRadius itemReturnDialog      = BorderRadius.all(Radius.circular(xxl));
//   static const BorderRadius itemReturnInnerDialog = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius itemReturnDialogField = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius itemReturnOutBtn      = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius itemReturnEmptyIcon   = BorderRadius.all(Radius.circular(xl));
//
//   // ── SQC bottom sheet sub-elements ────────────────
//   static const BorderRadius sqcDragHandle = BorderRadius.all(Radius.circular(xxs));
//   static const BorderRadius sqcDot        = BorderRadius.all(Radius.circular(xxs));
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// XMI list card outer container. Was: BorderRadius.circular(18)
//   static const BorderRadius xmiCard             = BorderRadius.all(Radius.circular(18));
//   /// Vehicle icon badge in card header. Was: BorderRadius.circular(13)
//   static const BorderRadius xmiVehicleIconBadge = BorderRadius.all(Radius.circular(13));
//   /// Status badge (Received / Pending). Was: BorderRadius.circular(20)
//   static const BorderRadius xmiStatusBadge      = BorderRadius.all(Radius.circular(xxl));
//   /// Expand toggle bottom border. Was: BorderRadius.vertical(bottom: Radius.circular(18))
//   static const BorderRadius xmiToggleBottom     = BorderRadius.only(
//     bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18),
//   );
//   /// Dialog shape. Was: BorderRadius.circular(18)
//   static const BorderRadius xmiDialog           = BorderRadius.all(Radius.circular(18));
//   /// Action button pill shape. Was: BorderRadius.circular(50)
//   static const BorderRadius xmiActionBtn        = BorderRadius.all(Radius.circular(full));
//
//   // ── MarkDefectiveItem screens ─────────────────────
//   /// Form input / dropdown fields (12 px). Was: BorderRadius.circular(12)
//   static const BorderRadius markDefectiveInput      = BorderRadius.all(Radius.circular(12));
//   /// Delete icon container inside list rows (9 px). Was: BorderRadius.circular(9)
//   static const BorderRadius markDefectiveDeleteBtn  = BorderRadius.all(Radius.circular(9));
//   /// Icon badge inside the delete-confirmation dialog (15 px). Was: BorderRadius.circular(15)
//   static const BorderRadius markDefectiveDialogIcon = BorderRadius.all(Radius.circular(15));
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SHADOWS
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppShadows {
//   AppShadows._();
//
//   static const List<BoxShadow> card = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 12,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   static const List<BoxShadow> chip = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 6,
//       offset: Offset(0, 1),
//     ),
//   ];
//
//   static const List<BoxShadow> listItem = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 6,
//       offset: Offset(0, 1),
//     ),
//   ];
//
//   static const List<BoxShadow> tableBody = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 8,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   // ── StockSubmitToManager ──────────────────────────
//   static const List<BoxShadow> submitCard = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 10,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   static const List<BoxShadow> submitCardLg = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 12,
//       offset: Offset(0, 2),
//     ),
//   ];
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SIZES  (icon sizes, avatar dimensions, fixed heights, stroke widths)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppSizes {
//   AppSizes._();
//
//   // ── Delivery men screen ───────────────────────────
//   static const double deliveryAvatarSize  = 44.0;
//   static const double heroBackBtnSize     = 38.0;
//   static const double emptyStateIconSize  = 64.0;
//   static const double heroBackIconSize    = 16.0;
//   static const double emptyStateIconPx    = 30.0;
//   static const double chevronSize         = 22.0;
//   static const double searchIconSize      = 20.0;
//   static const double loadingStrokeWidth  = 2.5;
//   static const double iconMd              = 24.0;
//   static const double iconXss             = 14.0;
//   static const double iconXs              = 16.0;
//   static const double iconSm              = 20.0;
//   static const double iconLg              = 30.0;
//
//   // ── Stock / info-row icon badge ───────────────────
//   static const double infoIconBadgeSize   = 36.0;
//   static const double deliveryCardAccentBorderWidth = 4.0;
//   static const double infoIconSize        = 18.0;
//   static const double stockCardIconSize   = 40.0;
//   static const double stockCardIcon       = 20.0;
//   static const double tableActionIcon     = 14.0;
//   static const double miniSpinnerSize     = 24.0;
//   static const double miniSpinnerStroke   = 2.0;
//   static const double formBtnHeight       = 50.0;
//   static const double submitBtnHeight     = 52.0;
//   static const double sectionDotSize      = 8.0;
//   static const double historyListHeight   = 200.0;
//   static const double checkboxIconSize    = 16.0;
//
//   // ── StockSubmitToManager ──────────────────────────
//   static const double stockTableDividerWidth            = 1.0;
//   static const double stockTableDividerHeightHeader     = 8.0;
//   static const double stockTableDividerHeightRow        = 16.0;
//   static const double stockTableDividerHMargin          = 2.0;
//   static const double popupMenuIconSize                 = 22.0;
//
//   // ── ItemReturn screen ─────────────────────────────
//   static const double itemReturnCardAccentBorder  = 3.0;
//   static const double itemReturnCardShadowBlur    = 8.0;
//   static const double itemReturnVehicleIconBox    = 36.0;
//   static const double itemReturnVehicleIconSize   = 18.0;
//   static const double itemReturnActionIcon        = 18.0;
//   static const double itemReturnToggleIcon        = 18.0;
//   static const double itemReturnEmptyIconBox      = 56.0;
//   static const double itemReturnEmptyIconPx       = 28.0;
//   static const double itemReturnDialogIconBox     = 36.0;
//   static const double itemReturnDialogIconSize    = 20.0;
//
//   // ── SQC bottom sheet ──────────────────────────────
//   static const double sqcDragHandleWidth  = 36.0;
//   static const double sqcDragHandleHeight = 4.0;
//   static const double sqcDotSize         = 7.0;
//   static const double sqcVehicleIconBox  = 34.0;
//   static const double sqcVehicleIconSize = 17.0;
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// Vehicle icon badge container size. Was: 44×44
//   static const double xmiVehicleIconBox  = 44.0;
//   /// Vehicle icon pixel size inside badge. Was: 22
//   static const double xmiVehicleIconPx   = 22.0;
//   /// Empty-state icon box size. Was: 72×72
//   static const double xmiEmptyIconBox    = 72.0;
//   /// Empty-state icon pixel size. Was: 34
//   static const double xmiEmptyIconPx     = 34.0;
//   /// Toggle icon size. Was: 20
//   static const double xmiToggleIconSize  = 20.0;
//   /// Action button height. Was: 36
//   static const double xmiActionBtnHeight = 36.0;
//   /// Fixed width of each quantity column cell. Was: 62
//   static const double xmiQtyColWidth     = 62.0;
//   /// Loading spinner stroke width. Was: 3
//   static const double xmiLoadingStroke   = 3.0;
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // DECORATIONS  (reusable BoxDecoration bundles)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppDecorations {
//   AppDecorations._();
//
//   // ── Generic card ─────────────────────────────────
//   static BoxDecoration card({
//     Color? color,
//     BorderRadius? borderRadius,
//     List<BoxShadow>? shadows,
//   }) =>
//       BoxDecoration(
//         color: color ?? AppColors.surface,
//         borderRadius: borderRadius ?? AppRadius.card,
//         boxShadow: shadows ?? AppShadows.card,
//       );
//
//   // ── Card header (top rounded, light bg) ──────────
//   static const BoxDecoration cardHeader = BoxDecoration(
//     color: AppColors.surfaceMuted,
//     borderRadius: AppRadius.cardTop,
//   );
//
//   // ── Stock chip (top accent bar) ──────────────────
//   static BoxDecoration stockChipAccent({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.chip,
//     border: Border(top: BorderSide(color: accentColor, width: 3)),
//     boxShadow: AppShadows.chip,
//   );
//
//   // ── Dropdown pill (compact) ───────────────────────
//   static const BoxDecoration dropdownPill = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
//     border: Border.fromBorderSide(
//       BorderSide(color: AppColors.primaryXXLight),
//     ),
//   );
//
//   // ── Transfer / action button ──────────────────────
//   static BoxDecoration transferButton({required bool disabled}) => BoxDecoration(
//     color: disabled ? const Color(0xFFF3F4F6) : AppColors.redXLight,
//     borderRadius: AppRadius.button,
//     border: Border.all(
//       color: disabled ? const Color(0xFFD1D5DB) : AppColors.red.withOpacity(0.3),
//     ),
//   );
//
//   // ── Badge / status pill ───────────────────────────
//   static BoxDecoration statusBadge({required bool isPositive}) => BoxDecoration(
//     color: isPositive ? AppColors.greenXLight : AppColors.redXLight,
//     borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
//   );
//
//   // ── Modal bottom sheet drag handle ───────────────
//   static BoxDecoration dragHandle = BoxDecoration(
//     color: AppColors.primaryXXLight,
//     borderRadius: const BorderRadius.all(Radius.circular(10)),
//   );
//
//   // ── FAB ──────────────────────────────────────────
//   static const BoxDecoration fab = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: BorderRadius.all(Radius.circular(AppRadius.full)),
//   );
//
//   // ── Delivery man list card ────────────────────────
//   static const BoxDecoration deliveryCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryCard,
//     boxShadow: AppShadows.card,
//   );
//
//   // ── Delivery man avatar badge ─────────────────────
//   static const BoxDecoration deliveryAvatar = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.avatarBadge,
//   );
//
//   // ── Hero header back button ───────────────────────
//   static BoxDecoration heroBackButton = BoxDecoration(
//     color: Colors.white.withOpacity(0.15),
//     borderRadius: AppRadius.heroBackBtn,
//     border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
//   );
//
//   // ── Hero header count badge ───────────────────────
//   static BoxDecoration heroBadge = BoxDecoration(
//     color: Colors.white.withOpacity(0.15),
//     borderRadius: AppRadius.heroBadge,
//     border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
//   );
//
//   // ── Empty-state icon container ────────────────────
//   static const BoxDecoration emptyStateIcon = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.emptyStateIcon,
//   );
//
//   // ── Search field borders ──────────────────────────
//   static OutlineInputBorder searchBorderNone = OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide.none,
//   );
//   static OutlineInputBorder searchBorderEnabled = const OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide(color: AppColors.border, width: 1),
//   );
//   static OutlineInputBorder searchBorderFocused = const OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
//   );
//
//   // ── Stock / Transfer screens ──────────────────────
//   static const BoxDecoration formCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.formCard,
//     boxShadow: AppShadows.card,
//   );
//
//   static const BoxDecoration stockListItem = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryCard,
//     boxShadow: AppShadows.listItem,
//   );
//
//   static const BoxDecoration warningPanel = BoxDecoration(
//     color: AppColors.warningBg,
//     borderRadius: AppRadius.warningPanel,
//   );
//
//   static const BoxDecoration tableHeader = BoxDecoration(
//     color: AppColors.primary,
//     borderRadius: AppRadius.tableTop,
//   );
//
//   static const BoxDecoration tableBody = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.tableBottom,
//     boxShadow: AppShadows.tableBody,
//   );
//
//   static const BoxDecoration editActionBtn = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.actionIcon,
//   );
//
//   static const BoxDecoration deleteActionBtn = BoxDecoration(
//     color: AppColors.redXLight,
//     borderRadius: AppRadius.actionIcon,
//   );
//
//   static const BoxDecoration infoIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.iconBadge,
//   );
//
//   static const BoxDecoration stockCardIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.stockChip,
//   );
//
//   static BoxDecoration stockChip({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.chip,
//     border: Border(top: BorderSide(color: accentColor, width: 3)),
//     boxShadow: AppShadows.chip,
//   );
//
//   static const BoxDecoration acceptBtn = BoxDecoration(
//     color: AppColors.primary,
//     borderRadius: AppRadius.inlineBtn,
//   );
//
//   static const BoxDecoration dateBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.dateBadge,
//   );
//
//   static OutlineInputBorder formBorderEnabled = const OutlineInputBorder(
//     borderRadius: AppRadius.formDropdown,
//     borderSide: BorderSide(color: AppColors.border),
//   );
//   static OutlineInputBorder formBorderFocused = const OutlineInputBorder(
//     borderRadius: AppRadius.formDropdown,
//     borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
//   );
//
//   static final BoxDecoration searchBar = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.searchBar,
//     boxShadow: AppShadows.submitCard,
//   );
//
//   static BoxDecoration deliveryManCard({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     border: Border(
//       left: BorderSide(color: accentColor, width: AppSizes.deliveryCardAccentBorderWidth),
//     ),
//     boxShadow: AppShadows.submitCardLg,
//   );
//
//   static BoxDecoration deliveryManAvatar({required Color bgColor}) => BoxDecoration(
//     color: bgColor,
//     borderRadius: AppRadius.deliveryManAvatar,
//   );
//
//   static BoxDecoration statusPill({required Color bgColor}) => BoxDecoration(
//     color: bgColor,
//     borderRadius: AppRadius.statusPill,
//   );
//
//   static const BoxDecoration errorStateIcon = BoxDecoration(
//     color: AppColors.redXLight,
//     borderRadius: AppRadius.stateIconContainer,
//   );
//
//   static const BoxDecoration emptyStateIconBlue = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.stateIconContainer,
//   );
//
//   static const BoxDecoration sectionEmptyCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     boxShadow: AppShadows.submitCard,
//   );
//
//   static const BoxDecoration totalSaleCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     boxShadow: AppShadows.submitCardLg,
//   );
//
//   static const BoxDecoration totalSaleCardHeader = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.totalSaleCardTop,
//   );
//
//   static BoxDecoration heroHeaderIcon = BoxDecoration(
//     color: Colors.white.withOpacity(0.16),
//     borderRadius: AppRadius.heroIconContainer,
//     border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
//   );
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// XMI list card outer container.
//   static const BoxDecoration xmiCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.xmiCard,
//     boxShadow: AppShadows.card,
//   );
//
//   /// Vehicle icon badge inside XMI card header.
//   static const BoxDecoration xmiVehicleIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.xmiVehicleIconBadge,
//   );
//
//   /// Column header row background in the XMI item table.
//   static const BoxDecoration xmiTableHeaderRow = BoxDecoration(
//     color: AppColors.xmiTableHeaderBg,
//   );
//
//   /// Divider line inside XMI item table rows.
//   static Border xmiRowDivider = const Border(
//     bottom: BorderSide(color: AppColors.divider, width: 1),
//   );
// }



// import 'package:flutter/material.dart';
// import 'app_colors.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SPACING
// // ─────────────────────────────────────────────────────────────────────────────
//
// /// 4-pt grid spacing constants.
// /// Usage: SizedBox(height: AppSpacing.md)
// ///        Padding(padding: AppSpacing.cardPadding)
// class AppSpacing {
//   AppSpacing._();
//
//   static const double xxs  = 2.0;
//   static const double xs   = 4.0;
//   static const double sm   = 8.0;
//   static const double md   = 12.0;
//   static const double lg   = 16.0;
//   static const double xl   = 24.0;
//   static const double xxl  = 32.0;
//   static const double xxxl = 48.0;
//
//   // ── Pre-composed EdgeInsets ───────────────────────
//   static const EdgeInsets cardPadding      = EdgeInsets.all(lg);
//   static const EdgeInsets pagePadding      = EdgeInsets.fromLTRB(lg, 0, lg, xxl);
//   static const EdgeInsets chipPadding      = EdgeInsets.symmetric(horizontal: md, vertical: xs);
//   static const EdgeInsets rowPadding       = EdgeInsets.symmetric(horizontal: lg, vertical: sm + xs);
//   static const EdgeInsets sectionHeader    = EdgeInsets.fromLTRB(0, xxl, 0, sm);
//   static const EdgeInsets stockChip        = EdgeInsets.symmetric(vertical: 14, horizontal: 10);
//   static const EdgeInsets buttonPadding    = EdgeInsets.symmetric(horizontal: 14, vertical: 6);
//
//   // ── Delivery men list screen ──────────────────────
//   /// Horizontal + vertical padding for the search bar container.
//   static const EdgeInsets searchBarPadding = EdgeInsets.fromLTRB(lg, md, lg, md);
//   /// Padding applied to the scrollable list of delivery men items.
//   static const EdgeInsets listPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
//   /// Internal padding of each delivery man card row.
//   static const EdgeInsets deliveryCardPadding = EdgeInsets.symmetric(horizontal: lg, vertical: 14);
//   /// Hero header inner padding.
//   static const EdgeInsets heroHeaderPadding = EdgeInsets.fromLTRB(20, 16, 20, 20);
//   /// Count badge inside the hero header.
//   static const EdgeInsets heroBadgePadding = EdgeInsets.symmetric(horizontal: md, vertical: 6);
//
//   // ── Stock / Transfer screens ──────────────────────
//   /// Main body scroll padding for stock forms (DailyRefillSalePage, StockTransfer).
//   static const EdgeInsets formBodyPadding       = EdgeInsets.fromLTRB(16, 16, 16, 32);
//   /// Inner padding of form-card and summary-card containers.
//   static const EdgeInsets formCardPadding       = EdgeInsets.all(18);
//   /// Inner padding of each stock history list item.
//   static const EdgeInsets stockItemPadding      = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
//   /// Padding for the imbalance / less-empty warning panel.
//   static const EdgeInsets warningPanelPadding   = EdgeInsets.all(md);
//   /// Padding for small inline action buttons (Select Customer, etc.).
//   static const EdgeInsets inlineActionPadding   = EdgeInsets.symmetric(horizontal: 10, vertical: 6);
//   /// Padding for AppBar secondary TextButton actions.
//   static const EdgeInsets appBarActionPadding   = EdgeInsets.symmetric(horizontal: lg, vertical: 10);
//   /// Padding inside stock-count chips in summary cards.
//   static const EdgeInsets stockChipInner        = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   /// Padding inside compact stock badges on list items.
//   static const EdgeInsets stockBadgeInner       = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
//   /// Padding for the date badge pill in transfer history items.
//   static const EdgeInsets dateBadgePadding      = EdgeInsets.symmetric(horizontal: 9, vertical: xs);
//   /// Padding for the Accept button on transfer history items.
//   static const EdgeInsets acceptBtnPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
//   /// Content padding for dropdowns and text fields in forms.
//   static const EdgeInsets dropdownContentPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
//   /// Padding of each data table row.
//   static const EdgeInsets tableRowPadding       = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   /// Padding of the table header row.
//   static const EdgeInsets tableHeaderPadding    = EdgeInsets.symmetric(horizontal: md, vertical: 10);
//   /// InfoRow (icon + label + value) padding inside info cards.
//   static const EdgeInsets infoRowPadding        = EdgeInsets.symmetric(horizontal: lg, vertical: md);
//   static const EdgeInsets noItemCardPadding     = EdgeInsets.all(lg);
//   /// Size of the hero header icon container.
//   static const double heroIconContainerSize     = 44.0;
//   // ── StockSubmitToManager ──────────────────────────
//   /// Outer list padding for the _LoadedBody scrollable ListView.
//   static const EdgeInsets submitListPadding     = EdgeInsets.fromLTRB(lg, 0, lg, xl);
//   /// Fixed top section padding (search bar + labels above the list).
//   static const EdgeInsets submitTopPadding      = EdgeInsets.fromLTRB(lg, lg, lg, 0);
//   /// Padding inside the search bar TextField content area.
//   static const EdgeInsets searchInputPadding    = EdgeInsets.symmetric(vertical: 14, horizontal: lg);
//   /// Padding for the stock table column-header row.
//   static const EdgeInsets stockTableHeaderPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
//   /// Padding for each row inside the stock data table.
//   static const EdgeInsets stockTableRowPadding  = EdgeInsets.symmetric(vertical: xs);
//   /// Padding around the delivery-man card header row (name / status).
//   static const EdgeInsets deliveryManCardHeaderPadding =
//   EdgeInsets.symmetric(horizontal: 14, vertical: md);
//   /// Bottom margin between delivery-man cards in the list.
//   static const double deliveryManCardBottomMargin = md;
//   /// Padding for the "No pending data" empty card inside a section.
//   static const EdgeInsets sectionEmptyCardPadding = EdgeInsets.all(20);
//   /// Padding for the global error / empty body containers.
//   static const EdgeInsets bodyStatePadding      = EdgeInsets.all(xxl);
//   // ── ItemReturn screen ─────────────────────────────
//   /// List padding for the main receipt list. Was: EdgeInsets.symmetric(horizontal:12, vertical:10)
//   static const EdgeInsets itemReturnListPadding      = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
//   /// Outer bottom margin of each receipt card. Was: EdgeInsets.only(bottom:8)
//   static const EdgeInsets itemReturnCardMargin       = EdgeInsets.only(bottom: 8);
//   /// Inner padding of the card header row. Was: EdgeInsets.fromLTRB(12,10,10,8)
//   static const EdgeInsets itemReturnCardHeader       = EdgeInsets.fromLTRB(12, 10, 10, 8);
//   /// Status badge padding. Was: EdgeInsets.symmetric(horizontal:8, vertical:3)
//   static const EdgeInsets itemReturnStatusBadgePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
//   /// Item row (inside expanded list) padding. Was: EdgeInsets.symmetric(horizontal:12, vertical:10)
//   static const EdgeInsets itemReturnItemRowPadding   = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
//   /// Stock chip padding on item row. Was: EdgeInsets.symmetric(horizontal:7, vertical:2)
//   static const EdgeInsets itemReturnStockChipPadding = EdgeInsets.symmetric(horizontal: 7, vertical: 2);
//   /// Footer row padding. Was: EdgeInsets.fromLTRB(8,2,8,8)
//   static const EdgeInsets itemReturnFooterPadding    = EdgeInsets.fromLTRB(8, 2, 8, 8);
//   /// Toggle button inner padding. Was: EdgeInsets.symmetric(horizontal:4, vertical:6)
//   static const EdgeInsets itemReturnTogglePadding    = EdgeInsets.symmetric(horizontal: 4, vertical: 6);
//   /// Action icon button (Out/Edit) inner padding. Was: EdgeInsets.all(8)
//   static const EdgeInsets itemReturnActionBtnPadding = EdgeInsets.all(8);
//   /// "Out" ElevatedButton padding. Was: EdgeInsets.symmetric(horizontal:24, vertical:12)
//   static const EdgeInsets itemReturnOutBtnPadding    = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
//   /// Dialog icon + item name header padding. Was: EdgeInsets.symmetric(horizontal:12, vertical:8)
//   static const EdgeInsets itemReturnDialogItemHeader = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
//
//   // ── SQC bottom sheet ──────────────────────────────
//   /// Drag handle margin. Was: EdgeInsets.only(top:10, bottom:14)
//   static const EdgeInsets sqcDragHandleMargin  = EdgeInsets.only(top: 10, bottom: 14);
//   /// Sheet header padding. Was: EdgeInsets.fromLTRB(20,0,20,12)
//   static const EdgeInsets sqcHeaderPadding     = EdgeInsets.fromLTRB(20, 0, 20, 12);
//   /// Vehicle list padding. Was: EdgeInsets.symmetric(horizontal:16, vertical:8)
//   static const EdgeInsets sqcListPadding       = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
//   /// Each vehicle row padding. Was: EdgeInsets.symmetric(horizontal:14, vertical:10)
//   static const EdgeInsets sqcVehicleRowPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 10);
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// Outer list padding for ItemReturnXMIListScreen. Was: fromLTRB(16,8,16,24)
//   static const EdgeInsets xmiListPadding        = EdgeInsets.fromLTRB(lg, sm, lg, xl);
//   /// Bottom gap between each XMI list card. Was: only(bottom:12)
//   static const EdgeInsets xmiCardGap            = EdgeInsets.only(bottom: md);
//   /// Card header inner padding. Was: fromLTRB(16,14,16,12)
//   static const EdgeInsets xmiCardHeaderPadding  = EdgeInsets.fromLTRB(lg, 14, lg, md);
//   /// Table column-header row padding. Was: fromLTRB(16,8,16,8)
//   static const EdgeInsets xmiTableHeaderPadding = EdgeInsets.fromLTRB(lg, sm, lg, sm);
//   /// Item row inner padding. Was: fromLTRB(16,10,16,10)
//   static const EdgeInsets xmiItemRowPadding     = EdgeInsets.fromLTRB(lg, 10, lg, 10);
//   /// Action button row padding. Was: fromLTRB(16,10,16,4)
//   static const EdgeInsets xmiActionRowPadding   = EdgeInsets.fromLTRB(lg, 10, lg, xs);
//   /// Expand/collapse toggle padding. Was: fromLTRB(16,10,16,12)
//   static const EdgeInsets xmiTogglePadding      = EdgeInsets.fromLTRB(lg, 10, lg, md);
//   /// Status badge padding. Was: symmetric(horizontal:10, vertical:5)
//   static const EdgeInsets xmiStatusBadgePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
//   /// Action button horizontal padding. Was: symmetric(horizontal:24)
//   static const EdgeInsets xmiActionBtnPadding   = EdgeInsets.symmetric(horizontal: xl);
//
//   // ── Display / Hero ──
//   static const TextStyle heroTitle = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     color: Colors.white,
//     letterSpacing: -0.5,
//     height: 1.2,
//   );
//
//   static const TextStyle heroSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: Colors.white70,
//     letterSpacing: 0.1,
//   );
//
//   // ── KPI Numbers (large, bold, prominent) ──
//   static const TextStyle kpiValueXL = TextStyle(
//     fontSize: 30,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.8,
//     height: 1.0,
//   );
//
//   static const TextStyle kpiValueLG = TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.6,
//     height: 1.1,
//   );
//
//   static const TextStyle kpiValueMD = TextStyle(
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//     letterSpacing: -0.4,
//     height: 1.1,
//   );
//
//   static const TextStyle heroKpiValue = TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w800,
//     color: Colors.white,
//     letterSpacing: -0.6,
//     height: 1.0,
//   );
//
//   // ── Labels & Body ──
//   static const TextStyle labelSM = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMuted,
//     letterSpacing: 0.6,
//   );
//
//   static const TextStyle labelMD = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMuted,
//     letterSpacing: 0.1,
//   );
//
//   static const TextStyle cardTitle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle cardSubtitle = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textMuted,
//     height: 1.4,
//   );
//
//   static const TextStyle alertTitle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//     letterSpacing: -0.1,
//   );
//
//   static const TextStyle alertValue = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     letterSpacing: -0.2,
//   );
//
//   static const TextStyle sectionHeaderq = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMid,
//     letterSpacing: 0.8,
//   );
//
//   static const TextStyle seeAll = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.blueLight,
//   );
//
//   static const TextStyle progressLabel = TextStyle(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle progressValue = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w700,
//     color: AppColors.text,
//   );
//
//   static const TextStyle navLabel = TextStyle(
//     fontSize: 10,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.2,
//     height: 1.0,
//   );
//
//   static const TextStyle miniLabel = TextStyle(
//     fontSize: 11,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textMuted,
//     letterSpacing: 0.5,
//   );
//
//   static const TextStyle miniValue = TextStyle(
//     fontSize: 28,
//     fontWeight: FontWeight.w800,
//     letterSpacing: -0.8,
//     height: 1.0,
//   );
//
//   static const TextStyle badgeText = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.w700,
//     letterSpacing: 0.1,
//   );
//
//   static const TextStyle dataRowLabel = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle dataRowValue = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//   );
//
//   static const TextStyle profitRowLabel = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textMid,
//   );
//
//   static const TextStyle profitRowValue = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.w800,
//     color: AppColors.text,
//   );
//
//   static const TextStyle profitHighlightValue = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.w800,
//     color: AppColors.green,
//     letterSpacing: -0.5,
//   );
//
//   // ── Sizes / dimensions ─────────────────────────────────
//   /// Height of the search bar container.
//   static const double searchBarHeight           = 48.0;
//   /// Size of the avatar circle / square in delivery-man cards.
//   static const double deliveryAvatarSize        = 40.0;
//   /// Size of error / empty state icon container.
//   static const double stateIconContainerSize    = 64.0;
// /// Section-label color dot width / height (already in AppSpacing.sectionDotSize below).
// // (re-uses sectionDotSize = 8.0 already defined further down)
//
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // BORDER RADIUS
// // ─────────────────────────────────────────────────────────────────────────────
//
// // class AppRadius {
// //   AppRadius._();
// //
// //   static const double xs   = 4.0;
// //   static const double sm   = 8.0;
// //   static const double md   = 12.0;
// //   static const double lg   = 14.0;
// //   static const double xl   = 18.0;
// //   static const double xxl  = 24.0;
// //   static const double full = 50.0;
// //
// //   // ── Pre-composed BorderRadius ─────────────────────
// //   static const BorderRadius card        = BorderRadius.all(Radius.circular(xl));
// //   static const BorderRadius chip        = BorderRadius.all(Radius.circular(lg));
// //   static const BorderRadius button      = BorderRadius.all(Radius.circular(full));
// //   static const BorderRadius dialog      = BorderRadius.all(Radius.circular(lg));
// //   static const BorderRadius input       = BorderRadius.all(Radius.circular(sm));
// //   static const BorderRadius cardTop     = BorderRadius.vertical(top: Radius.circular(xl));
// //   static const BorderRadius cardBottom  = BorderRadius.vertical(bottom: Radius.circular(xl));
// //
// //   // ── Delivery screen ───────────────────────────────
// //   /// Card radius used on delivery man list items and search field.
// //   static const BorderRadius deliveryCard   = BorderRadius.all(Radius.circular(16));
// //   /// Avatar / initial badge inside delivery cards.
// //   static const BorderRadius avatarBadge   = BorderRadius.all(Radius.circular(13));
// //   /// Search input field.
// //   static const BorderRadius searchInput   = BorderRadius.all(Radius.circular(lg));
// //   /// Hero header back-button container.
// //   static const BorderRadius heroBackBtn   = BorderRadius.all(Radius.circular(11));
// //   /// Empty-state icon container.
// //   static const BorderRadius emptyStateIcon = BorderRadius.all(Radius.circular(18));
// //   /// Hero count badge.
// //   static const BorderRadius heroBadge     = BorderRadius.all(Radius.circular(20));
// //
// //   // ── Stock / Transfer screens ──────────────────────
// //   /// Radius used on form cards and summary cards.
// //   static const BorderRadius formCard      = BorderRadius.all(Radius.circular(xl));
// //   /// Radius used on inline action buttons (Select Customer, Accept, etc.).
// //   static const BorderRadius inlineBtn     = BorderRadius.all(Radius.circular(20));
// //   /// Date badge pill on transfer history items.
// //   static const BorderRadius dateBadge     = BorderRadius.all(Radius.circular(20));
// //   /// Checkbox chip border.
// //   static const BorderRadius checkboxChip  = BorderRadius.all(Radius.circular(sm));
// //   /// Stock count chip inside summary card.
// //   static const BorderRadius stockChip     = BorderRadius.all(Radius.circular(md));
// //   /// Warning / amber panel.
// //   static const BorderRadius warningPanel  = BorderRadius.all(Radius.circular(md));
// //   /// Table top-rounded header.
// //   static const BorderRadius tableTop      = BorderRadius.vertical(top: Radius.circular(lg));
// //   /// Table bottom-rounded body.
// //   static const BorderRadius tableBottom   = BorderRadius.vertical(bottom: Radius.circular(lg));
// //   /// Icon badge / icon box inside info/vehicle rows.
// //   static const BorderRadius iconBadge     = BorderRadius.all(Radius.circular(10));
// //   /// ElevatedButton / OutlinedButton on forms.
// //   static const BorderRadius formButton    = BorderRadius.all(Radius.circular(lg));
// //   /// AppBar TextButton action.
// //   static const BorderRadius appBarBtn     = BorderRadius.all(Radius.circular(sm));
// //   /// Edit/delete action icon button.
// //   static const BorderRadius actionIcon    = BorderRadius.all(Radius.circular(6));
// //   /// Dropdown form field border.
// //   static const BorderRadius formDropdown  = BorderRadius.all(Radius.circular(md));
// // }
//
// class AppRadius {
//   AppRadius._();
//
//   static const double xxs  =  4.0;
//   static const double xs   =  6.0;
//   static const double sm   =  8.0;
//   static const double md   = 10.0;
//   static const double lg   = 12.0;
//   static const double xl   = 16.0;
//   static const double xxl  = 20.0;
//   static const double xxxl = 24.0;
//   static const double full = 100.0;
//
//
//   // ── Pre-composed BorderRadius ─────────────────────
//   static const BorderRadius card        = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius cardTop     = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   static const BorderRadius chip        = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius stockChip   = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius input       = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius button      = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius inlineBtn   = BorderRadius.all(Radius.circular(xs));
//   static const BorderRadius dialog      = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius formCard    = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius formDropdown = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius deliveryCard = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius avatarBadge  = BorderRadius.all(Radius.circular(lg));
//   static const BorderRadius heroBackBtn  = BorderRadius.all(Radius.circular(md));
//   static const BorderRadius heroBadge    = BorderRadius.all(Radius.circular(full));
//   static const BorderRadius emptyStateIcon = BorderRadius.all(Radius.circular(18));
//   static const BorderRadius searchInput   = BorderRadius.all(Radius.circular(xl));
//   static const BorderRadius warningPanel  = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius tableTop      = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   static const BorderRadius tableBottom   = BorderRadius.only(
//     bottomLeft: Radius.circular(xl), bottomRight: Radius.circular(xl),
//   );
//   static const BorderRadius actionIcon    = BorderRadius.all(Radius.circular(xs));
//   static const BorderRadius iconBadge     = BorderRadius.all(Radius.circular(sm));
//   static const BorderRadius dateBadge     = BorderRadius.all(Radius.circular(full));
//
//   // ── StockSubmitToManager ─────────────────────────
//   /// Search bar container border radius.
//   static const BorderRadius searchBar           = BorderRadius.all(Radius.circular(14));
//   /// Delivery-man card border radius.
//   static const BorderRadius deliveryManCard     = BorderRadius.all(Radius.circular(xl));
//   /// Avatar badge inside delivery-man card header.
//   static const BorderRadius deliveryManAvatar   = BorderRadius.all(Radius.circular(11));
//   /// Status pill badge border radius (circular).
//   static const BorderRadius statusPill          = BorderRadius.all(Radius.circular(full));
//   /// Error / empty state icon container border radius.
//   static const BorderRadius stateIconContainer  = BorderRadius.all(Radius.circular(18));
//   /// Total-sale card top corners.
//   static const BorderRadius totalSaleCardTop    = BorderRadius.only(
//     topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
//   );
//   /// Hero header icon container border radius.
//   static const BorderRadius heroIconContainer   = BorderRadius.all(Radius.circular(13));
//   /// Section-label color dot border radius.
//   static const BorderRadius sectionDot          = BorderRadius.all(Radius.circular(xxs));
// //   /// AppBar TextButton action.
//   static const BorderRadius appBarBtn     = BorderRadius.all(Radius.circular(sm));
// //   /// Checkbox chip border.
//   static const BorderRadius checkboxChip  = BorderRadius.all(Radius.circular(sm));
// //   /// ElevatedButton / OutlinedButton on forms.
//   static const BorderRadius formButton    = BorderRadius.all(Radius.circular(lg));
//
//
//   // ── ItemReturn ────────────────────────────────────
//   /// Receipt card outer container. Was: BorderRadius.circular(14)
//   static const BorderRadius itemReturnCard        = BorderRadius.all(Radius.circular(14));
//   /// Bottom sheet top. Was: BorderRadius.vertical(top: Radius.circular(20))
//   static const BorderRadius itemReturnSheet       = BorderRadius.only(
//     topLeft: Radius.circular(xxl), topRight: Radius.circular(xxl),
//   );
//   /// Vehicle card in SQC list. Was: BorderRadius.circular(12)
//   static const BorderRadius itemReturnVehicleCard = BorderRadius.all(Radius.circular(lg));
//   /// Stock chip on each item row. Was: BorderRadius.circular(6)
//   static const BorderRadius itemReturnStockChip   = BorderRadius.all(Radius.circular(xs));
//   /// AlertDialog (main). Was: BorderRadius.circular(20)
//   static const BorderRadius itemReturnDialog      = BorderRadius.all(Radius.circular(xxl));
//   /// Inner AlertDialog (stock exceeded). Was: BorderRadius.circular(16)
//   static const BorderRadius itemReturnInnerDialog = BorderRadius.all(Radius.circular(xl));
//   /// Form fields inside dialog. Was: BorderRadius.circular(12)
//   static const BorderRadius itemReturnDialogField = BorderRadius.all(Radius.circular(lg));
//   /// "Out" ElevatedButton. Was: BorderRadius.circular(12)
//   static const BorderRadius itemReturnOutBtn      = BorderRadius.all(Radius.circular(lg));
//   /// Empty-state icon box. Was: BorderRadius.circular(16)
//   static const BorderRadius itemReturnEmptyIcon   = BorderRadius.all(Radius.circular(xl));
//
//   // ── SQC bottom sheet sub-elements ────────────────
//   /// Drag handle pill. Was: BorderRadius.circular(2)
//   static const BorderRadius sqcDragHandle = BorderRadius.all(Radius.circular(xxs));
//   /// Title dot. Was: BorderRadius.circular(2)
//   static const BorderRadius sqcDot        = BorderRadius.all(Radius.circular(xxs));
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// XMI list card outer container. Was: BorderRadius.circular(18)
//   static const BorderRadius xmiCard             = BorderRadius.all(Radius.circular(18));
//   /// Vehicle icon badge in card header. Was: BorderRadius.circular(13)
//   static const BorderRadius xmiVehicleIconBadge = BorderRadius.all(Radius.circular(13));
//   /// Status badge (Received / Pending). Was: BorderRadius.circular(20)
//   static const BorderRadius xmiStatusBadge      = BorderRadius.all(Radius.circular(xxl));
//   /// Expand toggle bottom border. Was: BorderRadius.vertical(bottom: Radius.circular(18))
//   static const BorderRadius xmiToggleBottom     = BorderRadius.only(
//     bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18),
//   );
//   /// Dialog shape. Was: BorderRadius.circular(18)
//   static const BorderRadius xmiDialog           = BorderRadius.all(Radius.circular(18));
//   /// Action button pill shape. Was: BorderRadius.circular(50)
//   static const BorderRadius xmiActionBtn        = BorderRadius.all(Radius.circular(full));
// }
//
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SHADOWS
// // ─────────────────────────────────────────────────────────────────────────────
//
// // class AppShadows {
// //   AppShadows._();
// //
// //   static const List<BoxShadow> card = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 12,
// //       offset: Offset(0, 2),
// //     ),
// //   ];
// //
// //   static const List<BoxShadow> chip = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 8,
// //       offset: Offset(0, 2),
// //     ),
// //   ];
// //
// //   /// Slightly lifted shadow for table body container.
// //   static const List<BoxShadow> tableBody = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 12,
// //       offset: Offset(0, 4),
// //     ),
// //   ];
// //
// //   /// Subtle shadow for stock history list items.
// //   static const List<BoxShadow> listItem = [
// //     BoxShadow(
// //       color: AppColors.shadowCard,
// //       blurRadius: 10,
// //       offset: Offset(0, 2),
// //     ),
// //   ];
// //
// //   static const List<BoxShadow> none = [];
// // }
//
// class AppShadows {
//   AppShadows._();
//
//   static const List<BoxShadow> card = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 12,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   static const List<BoxShadow> chip = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 6,
//       offset: Offset(0, 1),
//     ),
//   ];
//
//   static const List<BoxShadow> listItem = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 6,
//       offset: Offset(0, 1),
//     ),
//   ];
//
//   static const List<BoxShadow> tableBody = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 8,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   // ── StockSubmitToManager ──────────────────────────
//   /// Shadow used on search bar, delivery-man cards, and total-sale card.
//   static const List<BoxShadow> submitCard = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 10,
//       offset: Offset(0, 2),
//     ),
//   ];
//
//   /// Slightly larger shadow for delivery-man and total-sale cards.
//   static const List<BoxShadow> submitCardLg = [
//     BoxShadow(
//       color: AppColors.shadowCard,
//       blurRadius: 12,
//       offset: Offset(0, 2),
//     ),
//   ];
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // SIZES  (icon sizes, avatar dimensions, fixed heights, stroke widths)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppSizes {
//   AppSizes._();
//
//   // ── Delivery men screen ───────────────────────────
//   static const double deliveryAvatarSize  = 44.0;
//   static const double heroBackBtnSize     = 38.0;
//   static const double emptyStateIconSize  = 64.0;
//   static const double heroBackIconSize    = 16.0;
//   static const double emptyStateIconPx    = 30.0;
//   static const double chevronSize         = 22.0;
//   static const double searchIconSize      = 20.0;
//   static const double loadingStrokeWidth  = 2.5;
//   static const double iconMd           =  24.0;
//
//   static const double iconXss           =  14.0;
//   static const double iconXs           =  16.0;
//   static const double iconSm           =  20.0;
//   static const double iconLg           =  30.0;
//
//   // ── Stock / info-row icon badge ───────────────────
//   /// Square size of icon badge boxes (vehicle, calendar, person rows).
//   static const double infoIconBadgeSize   = 36.0;
//   /// Width of the left colored border on delivery-man cards.
//   static const double deliveryCardAccentBorderWidth = 4.0;
//   /// Icon size inside an info-row icon badge.
//   static const double infoIconSize        = 18.0;
//   /// Square size of icon badge inside stock summary cards.
//   static const double stockCardIconSize   = 40.0;
//   /// Icon size inside stock summary cards.
//   static const double stockCardIcon       = 20.0;
//   /// Edit/delete action icon inside table rows.
//   static const double tableActionIcon     = 14.0;
//   /// Compact loading spinner size (inside FutureBuilder awaiting state).
//   static const double miniSpinnerSize     = 24.0;
//   /// Stroke width for the mini loading spinner.
//   static const double miniSpinnerStroke   = 2.0;
//   /// Minimum height of primary ElevatedButton on forms.
//   static const double formBtnHeight       = 50.0;
//   /// Minimum height of the submit ElevatedButton (stock transfer).
//   static const double submitBtnHeight     = 52.0;
//   /// Section label dot width/height.
//   static const double sectionDotSize      = 8.0;
//   /// Stock history list fixed container height.
//   static const double historyListHeight   = 200.0;
//   /// Table header checkbox icon size.
//   static const double checkboxIconSize    = 16.0;
//
//   // ── StockSubmitToManager ──────────────────────────
//   /// Width of the column divider inside the stock table.
//   static const double stockTableDividerWidth  = 1.0;
//   /// Height of the column divider in the table header row.
//   static const double stockTableDividerHeightHeader = 8.0;
//   /// Height of the column divider in table data rows.
//   static const double stockTableDividerHeightRow    = 16.0;
//   /// Horizontal margin of column dividers.
//   static const double stockTableDividerHMargin      = 2.0;
//   /// Size of the more-vert popup icon.
//   static const double popupMenuIconSize       = 22.0;
//
//   // ── ItemReturn screen ─────────────────────────────
//   /// Card left accent border width. Was: 3
//   static const double itemReturnCardAccentBorder  = 3.0;
//   /// Card shadow blur radius. Was: 8
//   static const double itemReturnCardShadowBlur    = 8.0;
//   /// Vehicle icon box size (card header). Was: 36×36
//   static const double itemReturnVehicleIconBox    = 36.0;
//   /// Vehicle icon size (card header). Was: 18
//   static const double itemReturnVehicleIconSize   = 18.0;
//   /// Action icon button size (Out / Edit). Was: 18
//   static const double itemReturnActionIcon        = 18.0;
//   /// Toggle arrow icon size. Was: 18
//   static const double itemReturnToggleIcon        = 18.0;
//   /// Empty-state icon box. Was: 56×56
//   static const double itemReturnEmptyIconBox      = 56.0;
//   /// Empty-state icon pixel size. Was: 28
//   static const double itemReturnEmptyIconPx       = 28.0;
//   /// Dialog title icon box. Was: 36×36
//   static const double itemReturnDialogIconBox     = 36.0;
//   /// Dialog title icon size. Was: 20
//   static const double itemReturnDialogIconSize    = 20.0;
//
//   // ── SQC bottom sheet ──────────────────────────────
//   /// Drag handle width. Was: 36
//   static const double sqcDragHandleWidth  = 36.0;
//   /// Drag handle height. Was: 4
//   static const double sqcDragHandleHeight = 4.0;
//   /// Title accent dot size. Was: 7×7
//   static const double sqcDotSize         = 7.0;
//   /// Vehicle icon box in SQC list. Was: 34×34
//   static const double sqcVehicleIconBox  = 34.0;
//   /// Vehicle icon size in SQC list. Was: 17
//   static const double sqcVehicleIconSize = 17.0;
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// Vehicle icon badge container size. Was: 44×44
//   static const double xmiVehicleIconBox  = 44.0;
//   /// Vehicle icon pixel size inside badge. Was: 22
//   static const double xmiVehicleIconPx   = 22.0;
//   /// Empty-state icon box size. Was: 72×72
//   static const double xmiEmptyIconBox    = 72.0;
//   /// Empty-state icon pixel size. Was: 34
//   static const double xmiEmptyIconPx     = 34.0;
//   /// Toggle icon size. Was: 20
//   static const double xmiToggleIconSize  = 20.0;
//   /// Action button height. Was: 36
//   static const double xmiActionBtnHeight = 36.0;
//   /// Fixed width of each quantity column cell. Was: 62
//   static const double xmiQtyColWidth     = 62.0;
//   /// Loading spinner stroke width. Was: 3
//   static const double xmiLoadingStroke   = 3.0;
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // DECORATIONS  (reusable BoxDecoration bundles)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class AppDecorations {
//   AppDecorations._();
//
//   // ── Generic card ─────────────────────────────────
//   static BoxDecoration card({
//     Color? color,
//     BorderRadius? borderRadius,
//     List<BoxShadow>? shadows,
//   }) =>
//       BoxDecoration(
//         color: color ?? AppColors.surface,
//         borderRadius: borderRadius ?? AppRadius.card,
//         boxShadow: shadows ?? AppShadows.card,
//       );
//
//   // ── Card header (top rounded, light bg) ──────────
//   static const BoxDecoration cardHeader = BoxDecoration(
//     color: AppColors.surfaceMuted,
//     borderRadius: AppRadius.cardTop,
//   );
//
//   // ── Stock chip (top accent bar) ──────────────────
//   static BoxDecoration stockChipAccent({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.chip,
//     border: Border(top: BorderSide(color: accentColor, width: 3)),
//     boxShadow: AppShadows.chip,
//   );
//
//   // ── Dropdown pill (compact) ───────────────────────
//   static const BoxDecoration dropdownPill = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
//     border: Border.fromBorderSide(
//       BorderSide(color: AppColors.primaryXXLight),
//     ),
//   );
//
//   // ── Transfer / action button ──────────────────────
//   static BoxDecoration transferButton({required bool disabled}) => BoxDecoration(
//     color: disabled ? const Color(0xFFF3F4F6) : AppColors.redXLight,
//     borderRadius: AppRadius.button,
//     border: Border.all(
//       color: disabled ? const Color(0xFFD1D5DB) : AppColors.red.withOpacity(0.3),
//     ),
//   );
//
//   // ── Badge / status pill ───────────────────────────
//   static BoxDecoration statusBadge({required bool isPositive}) => BoxDecoration(
//     color: isPositive ? AppColors.greenXLight : AppColors.redXLight,
//     borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
//   );
//
//   // ── Modal bottom sheet drag handle ───────────────
//   static BoxDecoration dragHandle = BoxDecoration(
//     color: AppColors.primaryXXLight,
//     borderRadius: const BorderRadius.all(Radius.circular(10)),
//   );
//
//   // ── FAB ──────────────────────────────────────────
//   static const BoxDecoration fab = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: BorderRadius.all(Radius.circular(AppRadius.full)),
//   );
//
//   // ── Delivery man list card ────────────────────────
//   static const BoxDecoration deliveryCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryCard,
//     boxShadow: AppShadows.card,
//   );
//
//   // ── Delivery man avatar badge ─────────────────────
//   static const BoxDecoration deliveryAvatar = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.avatarBadge,
//   );
//
//   // ── Hero header back button ───────────────────────
//   static BoxDecoration heroBackButton = BoxDecoration(
//     color: Colors.white.withOpacity(0.15),
//     borderRadius: AppRadius.heroBackBtn,
//     border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
//   );
//
//   // ── Hero header count badge ───────────────────────
//   static BoxDecoration heroBadge = BoxDecoration(
//     color: Colors.white.withOpacity(0.15),
//     borderRadius: AppRadius.heroBadge,
//     border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
//   );
//
//   // ── Empty-state icon container ────────────────────
//   static const BoxDecoration emptyStateIcon = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.emptyStateIcon,
//   );
//
//   // ── Search field borders ──────────────────────────
//   static OutlineInputBorder searchBorderNone = OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide.none,
//   );
//   static OutlineInputBorder searchBorderEnabled = const OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide(color: AppColors.border, width: 1),
//   );
//   static OutlineInputBorder searchBorderFocused = const OutlineInputBorder(
//     borderRadius: AppRadius.searchInput,
//     borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
//   );
//
//   // ── Stock / Transfer screens ──────────────────────
//
//   /// White rounded-corner card used by form cards and summary cards.
//   static const BoxDecoration formCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.formCard,
//     boxShadow: AppShadows.card,
//   );
//
//   /// Stock history list item (white card, lighter shadow).
//   static const BoxDecoration stockListItem = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryCard,
//     boxShadow: AppShadows.listItem,
//   );
//
//   /// Amber warning / imbalance assignment panel.
//   static const BoxDecoration warningPanel = BoxDecoration(
//     color: AppColors.warningBg,
//     borderRadius: AppRadius.warningPanel,
//     // Border added dynamically because Border.all isn't const with runtime colors
//   );
//
//   /// Table header bar — primary blue, top-rounded only.
//   static const BoxDecoration tableHeader = BoxDecoration(
//     color: AppColors.primary,
//     borderRadius: AppRadius.tableTop,
//   );
//
//   /// Table body — white, bottom-rounded only.
//   static const BoxDecoration tableBody = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.tableBottom,
//     boxShadow: AppShadows.tableBody,
//   );
//
//   /// Edit action icon button — primary-tinted background.
//   static const BoxDecoration editActionBtn = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.actionIcon,
//   );
//
//   /// Delete action icon button — red-tinted background.
//   static const BoxDecoration deleteActionBtn = BoxDecoration(
//     color: AppColors.redXLight,
//     borderRadius: AppRadius.actionIcon,
//   );
//
//   /// Icon badge box used inside info rows (vehicle, calendar, person).
//   static const BoxDecoration infoIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.iconBadge,
//   );
//
//   /// Icon badge box inside stock summary card header.
//   static const BoxDecoration stockCardIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.stockChip, // circular(12)
//   );
//     static BoxDecoration stockChip({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.chip,
//     border: Border(top: BorderSide(color: accentColor, width: 3)),
//     boxShadow: AppShadows.chip,
//   );
//
//   /// Accept button on transfer history items.
//   static const BoxDecoration acceptBtn = BoxDecoration(
//     color: AppColors.primary,
//     borderRadius: AppRadius.inlineBtn,
//   );
//
//   /// Date badge pill on transfer history items.
//   static const BoxDecoration dateBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.dateBadge,
//   );
//
//   // ── Standard form field borders (used on dropdowns + textfields in forms) ──
//   static OutlineInputBorder formBorderEnabled = const OutlineInputBorder(
//     borderRadius: AppRadius.formDropdown,
//     borderSide: BorderSide(color: AppColors.border),
//   );
//   static OutlineInputBorder formBorderFocused = const OutlineInputBorder(
//     borderRadius: AppRadius.formDropdown,
//     borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
//   );
//
//
//
//   /// Search bar container decoration.
//   static final BoxDecoration searchBar = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.searchBar,
//     boxShadow: AppShadows.submitCard,
//   );
//
//   /// Delivery-man card outer container decoration (border applied dynamically
//   /// for the left status-color accent; boxShadow is constant).
//   static BoxDecoration deliveryManCard({required Color accentColor}) => BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     border: Border(
//       left: BorderSide(color: accentColor, width: AppSizes.deliveryCardAccentBorderWidth),
//     ),
//     boxShadow: AppShadows.submitCardLg,
//   );
//
//   /// Avatar badge inside delivery-man card (background = status bg color,
//   /// applied dynamically; shape is constant).
//   static BoxDecoration deliveryManAvatar({required Color bgColor}) => BoxDecoration(
//     color: bgColor,
//     borderRadius: AppRadius.deliveryManAvatar,
//   );
//
//   /// Status pill badge decoration (background = status bg color, applied dynamically).
//   static BoxDecoration statusPill({required Color bgColor}) => BoxDecoration(
//     color: bgColor,
//     borderRadius: AppRadius.statusPill,
//   );
//
//   /// Error state icon container.
//   static const BoxDecoration errorStateIcon = BoxDecoration(
//     color: AppColors.redXLight,
//     borderRadius: AppRadius.stateIconContainer,
//   );
//
//   /// Empty state icon container.
//   static const BoxDecoration emptyStateIconBlue = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.stateIconContainer,
//   );
//
//   /// Section-empty-card (e.g. "No summary data yet").
//   static const BoxDecoration sectionEmptyCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     boxShadow: AppShadows.submitCard,
//   );
//
//   /// Total-sale card container.
//   static const BoxDecoration totalSaleCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.deliveryManCard,
//     boxShadow: AppShadows.submitCardLg,
//   );
//
//   /// Total-sale card table header (blue-tinted, top-rounded).
//   static const BoxDecoration totalSaleCardHeader = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.totalSaleCardTop,
//   );
//
//   /// Hero header icon container (used in _HeroHeader).
//   static BoxDecoration heroHeaderIcon = BoxDecoration(
//     color: Colors.white.withOpacity(0.16),
//     borderRadius: AppRadius.heroIconContainer,
//     border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
//   );
//
//
//   // ── ItemReturnXMI screens (NEW) ───────────────────
//   /// XMI list card outer container.
//   static const BoxDecoration xmiCard = BoxDecoration(
//     color: AppColors.surface,
//     borderRadius: AppRadius.xmiCard,
//     boxShadow: AppShadows.card,
//   );
//
//   /// Vehicle icon badge inside XMI card header.
//   static const BoxDecoration xmiVehicleIconBadge = BoxDecoration(
//     color: AppColors.primaryXLight,
//     borderRadius: AppRadius.xmiVehicleIconBadge,
//   );
//
//   /// Column header row background in the XMI item table.
//   static const BoxDecoration xmiTableHeaderRow = BoxDecoration(
//     color: AppColors.xmiTableHeaderBg,
//   );
//
//   /// Divider line inside XMI item table rows.
//   static Border xmiRowDivider = const Border(
//     bottom: BorderSide(color: AppColors.divider, width: 1),
//   );
// }


import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SPACING
// ─────────────────────────────────────────────────────────────────────────────

/// 4-pt grid spacing constants.
/// Usage: SizedBox(height: AppSpacing.md)
///        Padding(padding: AppSpacing.cardPadding)
class AppSpacing {
  AppSpacing._();

  static const double xxs  = 2.0;
  static const double xs   = 4.0;
  static const double smm   = 6.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 24.0;
  static const double xxl  = 32.0;
  static const double xxxl = 48.0;

  // ── Pre-composed EdgeInsets ───────────────────────
  static const EdgeInsets cardPadding      = EdgeInsets.all(lg);
  static const EdgeInsets pagePadding      = EdgeInsets.fromLTRB(lg, 0, lg, xxl);
  static const EdgeInsets chipPadding      = EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static const EdgeInsets rowPadding       = EdgeInsets.symmetric(horizontal: lg, vertical: sm + xs);
  static const EdgeInsets sectionHeader    = EdgeInsets.fromLTRB(0, xxl, 0, sm);
  static const EdgeInsets stockChip        = EdgeInsets.symmetric(vertical: 14, horizontal: 10);
  static const EdgeInsets buttonPadding    = EdgeInsets.symmetric(horizontal: 14, vertical: 6);

  // ── Delivery men list screen ──────────────────────
  static const EdgeInsets searchBarPadding = EdgeInsets.fromLTRB(lg, md, lg, md);
  static const EdgeInsets listPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
  static const EdgeInsets deliveryCardPadding = EdgeInsets.symmetric(horizontal: lg, vertical: 14);
  static const EdgeInsets heroHeaderPadding = EdgeInsets.fromLTRB(20, 16, 20, 20);
  static const EdgeInsets heroBadgePadding = EdgeInsets.symmetric(horizontal: md, vertical: 6);

  // ── Stock / Transfer screens ──────────────────────
  static const EdgeInsets formBodyPadding       = EdgeInsets.fromLTRB(16, 16, 16, 32);
  static const EdgeInsets formCardPadding       = EdgeInsets.all(18);
  static const EdgeInsets stockItemPadding      = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const EdgeInsets warningPanelPadding   = EdgeInsets.all(md);
  static const EdgeInsets inlineActionPadding   = EdgeInsets.symmetric(horizontal: 10, vertical: 6);
  static const EdgeInsets appBarActionPadding   = EdgeInsets.symmetric(horizontal: lg, vertical: 10);
  static const EdgeInsets stockChipInner        = EdgeInsets.symmetric(horizontal: md, vertical: 10);
  static const EdgeInsets stockBadgeInner       = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const EdgeInsets dateBadgePadding      = EdgeInsets.symmetric(horizontal: 9, vertical: xs);
  static const EdgeInsets acceptBtnPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
  static const EdgeInsets dropdownContentPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 14);
  static const EdgeInsets tableRowPadding       = EdgeInsets.symmetric(horizontal: md, vertical: 10);
  static const EdgeInsets tableHeaderPadding    = EdgeInsets.symmetric(horizontal: md, vertical: 10);
  static const EdgeInsets infoRowPadding        = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets noItemCardPadding     = EdgeInsets.all(lg);
  static const double heroIconContainerSize     = 44.0;

  // ── StockSubmitToManager ──────────────────────────
  static const EdgeInsets submitListPadding     = EdgeInsets.fromLTRB(lg, 0, lg, xl);
  static const EdgeInsets submitTopPadding      = EdgeInsets.fromLTRB(lg, lg, lg, 0);
  static const EdgeInsets searchInputPadding    = EdgeInsets.symmetric(vertical: 14, horizontal: lg);
  static const EdgeInsets stockTableHeaderPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets stockTableRowPadding  = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets deliveryManCardHeaderPadding =
  EdgeInsets.symmetric(horizontal: 14, vertical: md);
  static const double deliveryManCardBottomMargin = md;
  static const EdgeInsets sectionEmptyCardPadding = EdgeInsets.all(20);
  static const EdgeInsets bodyStatePadding      = EdgeInsets.all(xxl);

  // ── ItemReturn screen ─────────────────────────────
  static const EdgeInsets itemReturnListPadding      = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static const EdgeInsets itemReturnCardMargin       = EdgeInsets.only(bottom: 8);
  static const EdgeInsets itemReturnCardHeader       = EdgeInsets.fromLTRB(12, 10, 10, 8);
  static const EdgeInsets itemReturnStatusBadgePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
  static const EdgeInsets itemReturnItemRowPadding   = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
  static const EdgeInsets itemReturnStockChipPadding = EdgeInsets.symmetric(horizontal: 7, vertical: 2);
  static const EdgeInsets itemReturnFooterPadding    = EdgeInsets.fromLTRB(8, 2, 8, 8);
  static const EdgeInsets itemReturnTogglePadding    = EdgeInsets.symmetric(horizontal: 4, vertical: 6);
  static const EdgeInsets itemReturnActionBtnPadding = EdgeInsets.all(8);
  static const EdgeInsets itemReturnOutBtnPadding    = EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  static const EdgeInsets itemReturnDialogItemHeader = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  // ── SQC bottom sheet ──────────────────────────────
  static const EdgeInsets sqcDragHandleMargin  = EdgeInsets.only(top: 10, bottom: 14);
  static const EdgeInsets sqcHeaderPadding     = EdgeInsets.fromLTRB(20, 0, 20, 12);
  static const EdgeInsets sqcListPadding       = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const EdgeInsets sqcVehicleRowPadding = EdgeInsets.symmetric(horizontal: 14, vertical: 10);

  // ── ItemReturnXMI screens (NEW) ───────────────────
  /// Outer list padding for ItemReturnXMIListScreen. Was: fromLTRB(16,8,16,24)
  static const EdgeInsets xmiListPadding        = EdgeInsets.fromLTRB(lg, sm, lg, xl);
  /// Bottom gap between each XMI list card. Was: only(bottom:12)
  static const EdgeInsets xmiCardGap            = EdgeInsets.only(bottom: md);
  /// Card header inner padding. Was: fromLTRB(16,14,16,12)
  static const EdgeInsets xmiCardHeaderPadding  = EdgeInsets.fromLTRB(lg, 14, lg, md);
  /// Table column-header row padding. Was: fromLTRB(16,8,16,8)
  static const EdgeInsets xmiTableHeaderPadding = EdgeInsets.fromLTRB(lg, sm, lg, sm);
  /// Item row inner padding. Was: fromLTRB(16,10,16,10)
  static const EdgeInsets xmiItemRowPadding     = EdgeInsets.fromLTRB(lg, 10, lg, 10);
  /// Action button row padding. Was: fromLTRB(16,10,16,4)
  static const EdgeInsets xmiActionRowPadding   = EdgeInsets.fromLTRB(lg, 10, lg, xs);
  /// Expand/collapse toggle padding. Was: fromLTRB(16,10,16,12)
  static const EdgeInsets xmiTogglePadding      = EdgeInsets.fromLTRB(lg, 10, lg, md);
  /// Status badge padding. Was: symmetric(horizontal:10, vertical:5)
  static const EdgeInsets xmiStatusBadgePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  /// Action button horizontal padding. Was: symmetric(horizontal:24)
  static const EdgeInsets xmiActionBtnPadding   = EdgeInsets.symmetric(horizontal: xl);

  // ── MarkDefectiveItem screens ─────────────────────
  /// Outer body scroll padding (page sides + bottom). Was: fromLTRB(16, 0, 16, 24)
  static const EdgeInsets markDefectivePagePadding = EdgeInsets.fromLTRB(lg, 0, lg, xl);
  /// Vertical padding for the Submit ElevatedButton. Was: symmetric(vertical: 15)
  static const EdgeInsets markDefectiveSubmitBtn   = EdgeInsets.symmetric(vertical: 15);
  /// Gap between form fields inside the entry card. Was: SizedBox(height: 14)
  static const double     markDefectiveFieldGap    = 14.0;

  // ── MoreOptionScreenGodownKeeper ─────────────────────────
  /// Scrollable body padding. Was: EdgeInsets.fromLTRB(16, 20, 16, 32)
  static const EdgeInsets moreOptionsPagePadding        = EdgeInsets.fromLTRB(lg, 20, lg, xxl);
  /// Gap between section blocks (SizedBox height). Was: 6
  static const double     menuSectionGap                = 6.0;
  /// Section label outer padding. Was: EdgeInsets.only(bottom:10, top:4)
  static const EdgeInsets moreOptionsSectionLabelPadding = EdgeInsets.only(bottom: 10, top: xs);
  /// MenuCard outer bottom margin. Was: EdgeInsets.only(bottom:10)
  static const EdgeInsets moreOptionsMenuCardMargin     = EdgeInsets.only(bottom: 10);
  /// MenuTile inner padding. Was: EdgeInsets.symmetric(horizontal:16, vertical:14)
  static const EdgeInsets moreOptionsMenuTilePadding    = EdgeInsets.symmetric(horizontal: lg, vertical: 14);
  /// Gap between icon block and text column inside a tile. Was: 14
  static const double     moreOptionsIconTextGap        = 14.0;
  /// Logout dialog actions area padding. Was: EdgeInsets.symmetric(h:16, v:12)
  static const EdgeInsets moreOptionsDialogActions      = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  /// Logout dialog buttons padding. Was: EdgeInsets.symmetric(h:20, v:10)
  static const EdgeInsets moreOptionsDialogBtnPadding   = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  /// Hero header padding (inside _HeroHeader). Was: EdgeInsets.fromLTRB(20,16,20,22)
  static const EdgeInsets moreOptionsHeroHeaderPadding  = EdgeInsets.fromLTRB(20, 16, 20, 22);
  /// Gap between hero icon and text column. Was: 14
  static const double     moreOptionsHeroIconGap        = 14.0;

  // ── Display / Hero ──
  static const TextStyle heroTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    letterSpacing: 0.1,
  );

  // ── KPI Numbers (large, bold, prominent) ──
  static const TextStyle kpiValueXL = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.8,
    height: 1.0,
  );

  static const TextStyle kpiValueLG = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.6,
    height: 1.1,
  );

  static const TextStyle kpiValueMD = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
    letterSpacing: -0.4,
    height: 1.1,
  );

  // ── Labels & Body ──
  static const TextStyle labelSM = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.6,
  );

  static const TextStyle labelMD = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0.1,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.1,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle alertTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.1,
  );

  static const TextStyle alertValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
  );

  static const TextStyle sectionHeaderq = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textMid,
    letterSpacing: 0.8,
  );

  static const TextStyle seeAll = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.blueLight,
  );

  static const TextStyle progressLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textMid,
  );

  static const TextStyle progressValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.0,
  );

  static const TextStyle miniLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
  );

  static const TextStyle miniValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.0,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  static const TextStyle dataRowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textMid,
  );

  static const TextStyle dataRowValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static const TextStyle profitRowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textMid,
  );

  static const TextStyle profitRowValue = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );

  static const TextStyle profitHighlightValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.green,
    letterSpacing: -0.5,
  );

  // ── Sizes / dimensions ─────────────────────────────────
  static const double searchBarHeight           = 48.0;
  static const double deliveryAvatarSize        = 40.0;
  static const double stateIconContainerSize    = 64.0;

  // ── SQC Register Screen ──────────────────────────────────
  /// Main body scroll padding. Was: EdgeInsets.fromLTRB(16, 0, 16, 32)
  static const EdgeInsets sqcRegisterBodyPadding  = EdgeInsets.fromLTRB(lg, 0, lg, xxl);
  /// Inner padding of each FormCard. Was: EdgeInsets.all(16)
  static const EdgeInsets sqcFormCardPadding      = EdgeInsets.all(lg);
  /// Gap between paired weight fields. Was: SizedBox(height: 14)
  static const double     sqcFieldGap             = 14.0;
  /// Horizontal gap between side-by-side weight fields. Was: SizedBox(width: 12)
  static const double     sqcFieldHGap            = 12.0;
  /// Padding inside inline text fields (DPT Date). Was: symmetric(horizontal:14, vertical:12)
  static const EdgeInsets sqcInputContentPadding  = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  /// Padding for the Upload button row. Was: EdgeInsets.all(16)
  static const EdgeInsets sqcUploadRowPadding     = EdgeInsets.all(lg);
  /// Padding inside the ZIP chip indicator. Was: EdgeInsets.all(10)
  static const EdgeInsets sqcZipChipPadding       = EdgeInsets.all(10);
  /// SQC section header padding. Was: fromLTRB(0, 10, 0, 8)
  static const EdgeInsets sqcSectionHeaderPadding = EdgeInsets.fromLTRB(0, 10, 0, 8);
  /// Bottom-sheet modal: vertical padding. Was: symmetric(vertical: 8)
  static const EdgeInsets sqcModalVerticalPadding = EdgeInsets.symmetric(vertical: 8);
  /// Bottom sheet media option container (icon badge). Was: 38×38
  static const double     sqcMediaIconBox         = 38.0;
  /// Section dot size in _SectionHeader. Was: 8×8
  static const double     sqcSectionDotSize       = 8.0;
  /// Bottom margin of _FormCard. Was: EdgeInsets.only(bottom: 4)
  static const EdgeInsets sqcFormCardMargin       = EdgeInsets.only(bottom: 4);
  /// Defect upload card: icon container size. Was: 40×40
  static const double     sqcUploadIconBox        = 40.0;
  /// Receipt / queue card row padding. Was: EdgeInsets.all(16)
  static const EdgeInsets sqcReceiptRowPadding    = EdgeInsets.all(lg);
  /// Receipt card metric row gap. Was: SizedBox(width: 8)
  static const double     sqcMetricGap            = 8.0;
  /// Metric pill inner padding. Was: symmetric(horizontal:8, vertical:6)
  static const EdgeInsets sqcMetricPillPadding    = EdgeInsets.symmetric(horizontal: 8, vertical: 6);
  /// Queue card table header padding. Was: symmetric(horizontal:16, vertical:10)
  static const EdgeInsets sqcQueueHeaderPadding   = EdgeInsets.symmetric(horizontal: lg, vertical: 10);
  /// Queue item row padding. Was: symmetric(horizontal:16, vertical:12)
  static const EdgeInsets sqcQueueRowPadding      = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  /// Leaky badge padding. Was: symmetric(horizontal:6, vertical:2)
  static const EdgeInsets sqcLeakyBadgePadding    = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  /// Hero strip inner padding. Was: fromLTRB(20, 16, 20, 22)
  static const EdgeInsets sqcHeroStripPadding     = EdgeInsets.fromLTRB(20, 16, 20, 22);
  /// Hero vehicle badge padding. Was: symmetric(horizontal:10, vertical:4)
  static const EdgeInsets sqcHeroVehicleBadge     = EdgeInsets.symmetric(horizontal: 10, vertical: 4);
  /// Save/Update / Cancel button vertical padding. Was: symmetric(vertical: 14)
  static const EdgeInsets sqcActionBtnPadding     = EdgeInsets.symmetric(vertical: 14);
  /// Gap between Cancel and Save buttons. Was: SizedBox(width: 12)
  static const double     sqcActionBtnGap         = 12.0;
  /// Add-to-Queue button vertical padding. Was: symmetric(vertical: 14)
  static const EdgeInsets sqcAddBtnPadding        = EdgeInsets.symmetric(vertical: 14);
  /// Bottom-sheet drag handle size. Was: width:40, height:4
  static const double     sqcModalDragHandleW     = 40.0;
  static const double     sqcModalDragHandleH     = 4.0;
  /// Bottom margin of drag handle. Was: only(bottom: 12)
  static const EdgeInsets sqcModalDragHandleMargin = EdgeInsets.only(bottom: 12);
  /// Dropdown container horizontal+vertical padding. Was: symmetric(horizontal:14, vertical:2)
  static const EdgeInsets sqcDropdownPadding      = EdgeInsets.symmetric(horizontal: 14, vertical: 2);
  /// Read-only field inner padding. Was: symmetric(horizontal:14, vertical:12)
  static const EdgeInsets sqcReadOnlyPadding      = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  /// Queue action icon (edit/delete) container size. Was: 30×30
  static const double     sqcQueueActionIconBox   = 30.0;
  /// Receipt metric icon badge size. Was: 36×36
  static const double     sqcReceiptIconBox       = 36.0;
  /// Receipt icon badge border radius. Was: BorderRadius.circular(10)
  static const BorderRadius sqcIconBadgeRadius    = BorderRadius.all(Radius.circular(10));
  /// Receipt card edit button padding. Was: symmetric(horizontal:12, vertical:8)
  static const EdgeInsets sqcEditBtnPadding       = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  /// Empty receipt card padding. Was: EdgeInsets.all(24)
  static const EdgeInsets sqcEmptyCardPadding     = EdgeInsets.all(24);

  // ── Imbalance Sheet / ShowUI ──────────────────────
  /// Scrollable content padding of the imbalance bottom sheet.
  /// Was: EdgeInsets.only(bottom: viewInsets.bottom+16, left:16, right:16, top:12)
  static const EdgeInsets imbalanceSheetContentPadding =
  EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// Inner padding of _FieldCard containers in ImbalanceSheet.
  /// Was: EdgeInsets.symmetric(horizontal: 14, vertical: 10)
  static const EdgeInsets imbalanceFieldCardPadding =
  EdgeInsets.symmetric(horizontal: 14, vertical: 10);

  /// Bottom margin between _FieldCard containers.
  /// Was: EdgeInsets.only(bottom: 12)
  static const EdgeInsets imbalanceFieldCardMargin =
  EdgeInsets.only(bottom: md);

  /// Inner padding of _TableHeader row in ImbalanceSheet.
  /// Was: EdgeInsets.symmetric(horizontal: 14, vertical: 10)
  static const EdgeInsets imbalanceTableHeaderPadding =
  EdgeInsets.symmetric(horizontal: 14, vertical: 10);

  /// Inner padding of each _TableRow in ImbalanceSheet.
  /// Was: EdgeInsets.symmetric(horizontal: 14, vertical: 10)
  static const EdgeInsets imbalanceTableRowPadding =
  EdgeInsets.symmetric(horizontal: 14, vertical: 10);

  /// Inner padding of _FieldCard AUTO badge container.
  /// Was: EdgeInsets.symmetric(horizontal: 8, vertical: 3)
  static const EdgeInsets imbalanceAutoBadgePadding =
  EdgeInsets.symmetric(horizontal: sm, vertical: 3);

  /// Padding of the History button in the sheet header.
  /// Was: EdgeInsets.symmetric(horizontal: 12, vertical: 7)
  static const EdgeInsets imbalanceHistoryBtnPadding =
  EdgeInsets.symmetric(horizontal: md, vertical: 7);

  /// Drag handle top margin on the imbalance bottom sheet.
  /// Was: EdgeInsets.only(top: 12, bottom: 4)
  static const EdgeInsets imbalanceDragHandleMargin =
  EdgeInsets.only(top: md, bottom: xs);

  /// Width of the left accent bar in the sheet title.
  /// Was: width: 4, height: 28
  static const double imbalanceAccentBarWidth  = 4.0;
  static const double imbalanceAccentBarHeight = 28.0;

  /// Drag handle dimensions (width: 40, height: 4).
  static const double imbalanceDragHandleWidth  = 40.0;
  static const double imbalanceDragHandleHeight = 4.0;

  /// Padding inside the empty-state section of the list.
  /// Was: EdgeInsets.all(24)
  static const EdgeInsets imbalanceEmptyPadding = EdgeInsets.all(xl);

  /// Padding of the _ImbalanceRow container in ImblanceShowUi.
  /// Was: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
  static const EdgeInsets imbalanceRowPadding =
  EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// Padding of the type badge in _ImbalanceRow.
  /// Was: EdgeInsets.symmetric(horizontal: 8, vertical: 3)
  static const EdgeInsets imbalanceTypeBadgePadding =
  EdgeInsets.symmetric(horizontal: sm, vertical: 3);

  /// Padding of the empty placeholder in ImblanceShowUi.
  /// Was: EdgeInsets.symmetric(vertical: 32)
  static const EdgeInsets imbalancePlaceholderPadding =
  EdgeInsets.symmetric(vertical: xxl);

  /// Card header padding in ImblanceShowUi.
  /// Was: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
  static const EdgeInsets imbalanceCardHeaderPadding =
  EdgeInsets.symmetric(horizontal: lg, vertical: md);

}

// ─────────────────────────────────────────────────────────────────────────────
// BORDER RADIUS
// ─────────────────────────────────────────────────────────────────────────────

class AppRadius {
  AppRadius._();

  static const double xxs  =  4.0;
  static const double xs   =  6.0;
  static const double sm   =  8.0;
  static const double md   = 10.0;
  static const double lg   = 12.0;
  static const double xl   = 16.0;
  static const double xxl  = 20.0;
  static const double xxxl = 24.0;
  static const double full = 100.0;

  // ── Pre-composed BorderRadius ─────────────────────
  static const BorderRadius card        = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius cardTop     = BorderRadius.only(
    topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
  );
  static const BorderRadius chip        = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius stockChip   = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius input       = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius button      = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius inlineBtn   = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius dialog      = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius formCard    = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius formDropdown = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius deliveryCard = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius avatarBadge  = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius heroBackBtn  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius heroBadge    = BorderRadius.all(Radius.circular(full));
  static const BorderRadius emptyStateIcon = BorderRadius.all(Radius.circular(18));
  static const BorderRadius searchInput   = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius warningPanel  = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius tableTop      = BorderRadius.only(
    topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
  );
  static const BorderRadius tableBottom   = BorderRadius.only(
    bottomLeft: Radius.circular(xl), bottomRight: Radius.circular(xl),
  );
  static const BorderRadius actionIcon    = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius iconBadge     = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius dateBadge     = BorderRadius.all(Radius.circular(full));

  // ── StockSubmitToManager ─────────────────────────
  static const BorderRadius searchBar           = BorderRadius.all(Radius.circular(14));
  static const BorderRadius deliveryManCard     = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius deliveryManAvatar   = BorderRadius.all(Radius.circular(11));
  static const BorderRadius statusPill          = BorderRadius.all(Radius.circular(full));
  static const BorderRadius stateIconContainer  = BorderRadius.all(Radius.circular(18));
  static const BorderRadius totalSaleCardTop    = BorderRadius.only(
    topLeft: Radius.circular(xl), topRight: Radius.circular(xl),
  );
  static const BorderRadius heroIconContainer   = BorderRadius.all(Radius.circular(13));
  static const BorderRadius sectionDot          = BorderRadius.all(Radius.circular(xxs));
  static const BorderRadius appBarBtn     = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius checkboxChip  = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius formButton    = BorderRadius.all(Radius.circular(lg));

  // ── ItemReturn ────────────────────────────────────
  static const BorderRadius itemReturnCard        = BorderRadius.all(Radius.circular(14));
  static const BorderRadius itemReturnSheet       = BorderRadius.only(
    topLeft: Radius.circular(xxl), topRight: Radius.circular(xxl),
  );
  static const BorderRadius itemReturnVehicleCard = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius itemReturnStockChip   = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius itemReturnDialog      = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius itemReturnInnerDialog = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius itemReturnDialogField = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius itemReturnOutBtn      = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius itemReturnEmptyIcon   = BorderRadius.all(Radius.circular(xl));

  // ── SQC bottom sheet sub-elements ────────────────
  static const BorderRadius sqcDragHandle = BorderRadius.all(Radius.circular(xxs));
  static const BorderRadius sqcDot        = BorderRadius.all(Radius.circular(xxs));

  // ── ItemReturnXMI screens (NEW) ───────────────────
  /// XMI list card outer container. Was: BorderRadius.circular(18)
  static const BorderRadius xmiCard             = BorderRadius.all(Radius.circular(18));
  /// Vehicle icon badge in card header. Was: BorderRadius.circular(13)
  static const BorderRadius xmiVehicleIconBadge = BorderRadius.all(Radius.circular(13));
  /// Status badge (Received / Pending). Was: BorderRadius.circular(20)
  static const BorderRadius xmiStatusBadge      = BorderRadius.all(Radius.circular(xxl));
  /// Expand toggle bottom border. Was: BorderRadius.vertical(bottom: Radius.circular(18))
  static const BorderRadius xmiToggleBottom     = BorderRadius.only(
    bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18),
  );
  /// Dialog shape. Was: BorderRadius.circular(18)
  static const BorderRadius xmiDialog           = BorderRadius.all(Radius.circular(18));
  /// Action button pill shape. Was: BorderRadius.circular(50)
  static const BorderRadius xmiActionBtn        = BorderRadius.all(Radius.circular(full));

  // ── MarkDefectiveItem screens ─────────────────────
  /// Form input / dropdown fields (12 px). Was: BorderRadius.circular(12)
  static const BorderRadius markDefectiveInput      = BorderRadius.all(Radius.circular(12));
  /// Delete icon container inside list rows (9 px). Was: BorderRadius.circular(9)
  static const BorderRadius markDefectiveDeleteBtn  = BorderRadius.all(Radius.circular(9));
  /// Icon badge inside the delete-confirmation dialog (15 px). Was: BorderRadius.circular(15)
  static const BorderRadius markDefectiveDialogIcon = BorderRadius.all(Radius.circular(15));

  // ── MoreOptionScreenGodownKeeper ─────────────────────────
  /// Menu card and tile border radius. Was: BorderRadius.circular(18)
  static const BorderRadius moreOptionsMenuCard    = BorderRadius.all(Radius.circular(18));
  /// Icon box inside each tile. Was: BorderRadius.circular(13)
  static const BorderRadius moreOptionsIconBox     = BorderRadius.all(Radius.circular(13));
  /// Logout AlertDialog shape. Was: BorderRadius.circular(20)
  static const BorderRadius moreOptionsDialog      = BorderRadius.all(Radius.circular(xxl));
  /// Logout dialog icon box. Was: BorderRadius.circular(10)
  static const BorderRadius moreOptionsDialogIcon  = BorderRadius.all(Radius.circular(md));
  /// Logout dialog buttons. Was: BorderRadius.circular(10)
  static const BorderRadius moreOptionsDialogBtn   = BorderRadius.all(Radius.circular(md));


  // ── Imbalance Sheet / ShowUI ──────────────────────
  /// Border radius of _FieldCard containers in ImbalanceSheet.
  /// Was: BorderRadius.circular(14)
  static const BorderRadius imbalanceFieldCard =
  BorderRadius.all(Radius.circular(14));

  /// Border radius of the imbalance data table container.
  /// Was: BorderRadius.circular(14)
  static const BorderRadius imbalanceTable =
  BorderRadius.all(Radius.circular(14));

  /// Top-only radius for the _TableHeader row.
  /// Was: BorderRadius.vertical(top: Radius.circular(12))
  static const BorderRadius imbalanceTableTop =
  BorderRadius.only(topLeft: Radius.circular(lg), topRight: Radius.circular(lg));

  /// Border radius of action buttons (Close/Save) in ImbalanceSheet.
  /// Was: BorderRadius.circular(12)
  static const BorderRadius imbalanceBtn =
  BorderRadius.all(Radius.circular(lg));

  /// Border radius of the History button pill in the sheet header.
  /// Was: BorderRadius.circular(10)
  static const BorderRadius imbalanceHistoryBtn =
  BorderRadius.all(Radius.circular(md));

  /// Border radius of the AUTO badge in ImbalanceSheet.
  /// Was: BorderRadius.circular(6)
  static const BorderRadius imbalanceAutoBadge =
  BorderRadius.all(Radius.circular(xs));

  /// Border radius of the _TypeTab toggle in ImbalanceSheet.
  /// Was: BorderRadius.circular(10)
  static const BorderRadius imbalanceTypeTab =
  BorderRadius.all(Radius.circular(md));

  /// Border radius of the type toggle outer container.
  /// Was: BorderRadius.circular(14)
  static const BorderRadius imbalanceTypeToggle =
  BorderRadius.all(Radius.circular(14));

  /// Drag handle border radius in ImbalanceSheet.
  /// Was: BorderRadius.circular(2)
  static const BorderRadius imbalanceDragHandle =
  BorderRadius.all(Radius.circular(xxs));

  /// Left accent bar border radius in sheet title.
  /// Was: BorderRadius.circular(2)
  static const BorderRadius imbalanceAccentBar =
  BorderRadius.all(Radius.circular(xxs));

  /// Outer container border radius in ImblanceShowUi card.
  /// Was: BorderRadius.circular(16)
  static const BorderRadius imbalanceShowCard =
  BorderRadius.all(Radius.circular(xl));

  /// Top-only radius for the ImblanceShowUi card header.
  /// Was: BorderRadius.vertical(top: Radius.circular(16))
  static const BorderRadius imbalanceShowCardTop =
  BorderRadius.only(topLeft: Radius.circular(xl), topRight: Radius.circular(xl));

  /// Section dot border radius in ImbalanceSheet list header.
  /// Was: BorderRadius.circular(2)
  static const BorderRadius imbalanceSectionDot =
  BorderRadius.all(Radius.circular(xxs));

  /// Color dot border radius in _ImbalanceRow.
  /// Was: BorderRadius.circular(2)
  static const BorderRadius imbalanceColorDot =
  BorderRadius.all(Radius.circular(xxs));

  /// Type badge border radius in _ImbalanceRow.
  /// Was: BorderRadius.circular(8)
  static const BorderRadius imbalanceTypeBadge =
  BorderRadius.all(Radius.circular(sm));

  /// Empty-state icon container border radius in _EmptyPlaceholder.
  /// Was: BorderRadius.circular(14)
  static const BorderRadius imbalanceEmptyIcon =
  BorderRadius.all(Radius.circular(14));
}

// ─────────────────────────────────────────────────────────────────────────────
// SHADOWS
// ─────────────────────────────────────────────────────────────────────────────

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> chip = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 6,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> listItem = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 6,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> tableBody = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // ── StockSubmitToManager ──────────────────────────
  static const List<BoxShadow> submitCard = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> submitCardLg = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  // ── MoreOptionScreenGodownKeeper ─────────────────────────
  /// Shadow on _MenuCard. Was: BoxShadow(Color(0x0D1E3A8A), blur:12, offset:Offset(0,2))
  /// Color(0x0D1E3A8A) == AppColors.shadowCard ✓
  static const List<BoxShadow> moreOptionsMenuCard = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// SIZES  (icon sizes, avatar dimensions, fixed heights, stroke widths)
// ─────────────────────────────────────────────────────────────────────────────

class AppSizes {
  AppSizes._();

  // ── Delivery men screen ───────────────────────────
  static const double deliveryAvatarSize  = 44.0;
  static const double heroBackBtnSize     = 38.0;
  static const double emptyStateIconSize  = 64.0;
  static const double heroBackIconSize    = 16.0;
  static const double emptyStateIconPx    = 30.0;
  static const double chevronSize         = 22.0;
  static const double searchIconSize      = 20.0;
  static const double loadingStrokeWidth  = 2.5;
  static const double iconMd              = 24.0;
  static const double iconXss             = 14.0;
  static const double iconXs              = 16.0;
  static const double iconSm              = 20.0;
  static const double iconLg              = 30.0;

  // ── Stock / info-row icon badge ───────────────────
  static const double infoIconBadgeSize   = 36.0;
  static const double deliveryCardAccentBorderWidth = 4.0;
  static const double infoIconSize        = 18.0;
  static const double stockCardIconSize   = 40.0;
  static const double stockCardIcon       = 20.0;
  static const double tableActionIcon     = 14.0;
  static const double miniSpinnerSize     = 24.0;
  static const double miniSpinnerStroke   = 2.0;
  static const double formBtnHeight       = 50.0;
  static const double submitBtnHeight     = 52.0;
  static const double sectionDotSize      = 8.0;
  static const double historyListHeight   = 200.0;
  static const double checkboxIconSize    = 16.0;

  // ── StockSubmitToManager ──────────────────────────
  static const double stockTableDividerWidth            = 1.0;
  static const double stockTableDividerHeightHeader     = 8.0;
  static const double stockTableDividerHeightRow        = 16.0;
  static const double stockTableDividerHMargin          = 2.0;
  static const double popupMenuIconSize                 = 22.0;

  // ── ItemReturn screen ─────────────────────────────
  static const double itemReturnCardAccentBorder  = 3.0;
  static const double itemReturnCardShadowBlur    = 8.0;
  static const double itemReturnVehicleIconBox    = 36.0;
  static const double itemReturnVehicleIconSize   = 18.0;
  static const double itemReturnActionIcon        = 18.0;
  static const double itemReturnToggleIcon        = 18.0;
  static const double itemReturnEmptyIconBox      = 56.0;
  static const double itemReturnEmptyIconPx       = 28.0;
  static const double itemReturnDialogIconBox     = 36.0;
  static const double itemReturnDialogIconSize    = 20.0;

  // ── SQC bottom sheet ──────────────────────────────
  static const double sqcDragHandleWidth  = 36.0;
  static const double sqcDragHandleHeight = 4.0;
  static const double sqcDotSize         = 7.0;
  static const double sqcVehicleIconBox  = 34.0;
  static const double sqcVehicleIconSize = 17.0;

  // ── ItemReturnXMI screens (NEW) ───────────────────
  /// Vehicle icon badge container size. Was: 44×44
  static const double xmiVehicleIconBox  = 44.0;
  /// Vehicle icon pixel size inside badge. Was: 22
  static const double xmiVehicleIconPx   = 22.0;
  /// Empty-state icon box size. Was: 72×72
  static const double xmiEmptyIconBox    = 72.0;
  /// Empty-state icon pixel size. Was: 34
  static const double xmiEmptyIconPx     = 34.0;
  /// Toggle icon size. Was: 20
  static const double xmiToggleIconSize  = 20.0;
  /// Action button height. Was: 36
  static const double xmiActionBtnHeight = 36.0;
  /// Fixed width of each quantity column cell. Was: 62
  static const double xmiQtyColWidth     = 62.0;
  /// Loading spinner stroke width. Was: 3
  static const double xmiLoadingStroke   = 3.0;

  // ── MoreOptionScreenGodownKeeper ─────────────────────────
  /// Icon block container (width & height) in _MenuTile. Was: 44
  static const double moreOptionsIconBox        = 44.0;
  /// Icon pixel size inside the block. Was: 22
  static const double moreOptionsIconPx         = 22.0;
  /// Chevron icon size in _MenuTile. Was: 22
  static const double moreOptionsChevron        = 22.0;
  /// Logout dialog icon container size. Was: 36
  static const double moreOptionsDialogIconBox  = 36.0;
  /// Logout dialog icon pixel size. Was: 18
  static const double moreOptionsDialogIconPx   = 18.0;
  /// Hero header icon container size (_HeroHeader). Was: 42
  static const double moreOptionsHeroIconBox    = 42.0;
  /// Hero header icon pixel size. Was: 22
  static const double moreOptionsHeroIconPx     = 22.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// DECORATIONS  (reusable BoxDecoration bundles)
// ─────────────────────────────────────────────────────────────────────────────

class AppDecorations {
  AppDecorations._();

  // ── Generic card ─────────────────────────────────
  static BoxDecoration card({
    Color? color,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: borderRadius ?? AppRadius.card,
        boxShadow: shadows ?? AppShadows.card,
      );

  // ── Card header (top rounded, light bg) ──────────
  static const BoxDecoration cardHeader = BoxDecoration(
    color: AppColors.surfaceMuted,
    borderRadius: AppRadius.cardTop,
  );

  // ── Stock chip (top accent bar) ──────────────────
  static BoxDecoration stockChipAccent({required Color accentColor}) => BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.chip,
    border: Border(top: BorderSide(color: accentColor, width: 3)),
    boxShadow: AppShadows.chip,
  );

  // ── Dropdown pill (compact) ───────────────────────
  static const BoxDecoration dropdownPill = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.primaryXXLight),
    ),
  );

  // ── Transfer / action button ──────────────────────
  static BoxDecoration transferButton({required bool disabled}) => BoxDecoration(
    color: disabled ? const Color(0xFFF3F4F6) : AppColors.redXLight,
    borderRadius: AppRadius.button,
    border: Border.all(
      color: disabled ? const Color(0xFFD1D5DB) : AppColors.red.withOpacity(0.3),
    ),
  );

  // ── Badge / status pill ───────────────────────────
  static BoxDecoration statusBadge({required bool isPositive}) => BoxDecoration(
    color: isPositive ? AppColors.greenXLight : AppColors.redXLight,
    borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
  );

  // ── Modal bottom sheet drag handle ───────────────
  static BoxDecoration dragHandle = BoxDecoration(
    color: AppColors.primaryXXLight,
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );

  // ── FAB ──────────────────────────────────────────
  static const BoxDecoration fab = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.full)),
  );

  // ── Delivery man list card ────────────────────────
  static const BoxDecoration deliveryCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.deliveryCard,
    boxShadow: AppShadows.card,
  );

  // ── Delivery man avatar badge ─────────────────────
  static const BoxDecoration deliveryAvatar = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.avatarBadge,
  );

  // ── Hero header back button ───────────────────────
  static BoxDecoration heroBackButton = BoxDecoration(
    color: Colors.white.withOpacity(0.15),
    borderRadius: AppRadius.heroBackBtn,
    border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
  );

  // ── Hero header count badge ───────────────────────
  static BoxDecoration heroBadge = BoxDecoration(
    color: Colors.white.withOpacity(0.15),
    borderRadius: AppRadius.heroBadge,
    border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
  );

  // ── Empty-state icon container ────────────────────
  static const BoxDecoration emptyStateIcon = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.emptyStateIcon,
  );

  // ── Search field borders ──────────────────────────
  static OutlineInputBorder searchBorderNone = OutlineInputBorder(
    borderRadius: AppRadius.searchInput,
    borderSide: BorderSide.none,
  );
  static OutlineInputBorder searchBorderEnabled = const OutlineInputBorder(
    borderRadius: AppRadius.searchInput,
    borderSide: BorderSide(color: AppColors.border, width: 1),
  );
  static OutlineInputBorder searchBorderFocused = const OutlineInputBorder(
    borderRadius: AppRadius.searchInput,
    borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
  );

  // ── Stock / Transfer screens ──────────────────────
  static const BoxDecoration formCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.formCard,
    boxShadow: AppShadows.card,
  );

  static const BoxDecoration stockListItem = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.deliveryCard,
    boxShadow: AppShadows.listItem,
  );

  static const BoxDecoration warningPanel = BoxDecoration(
    color: AppColors.warningBg,
    borderRadius: AppRadius.warningPanel,
  );

  static const BoxDecoration tableHeader = BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppRadius.tableTop,
  );

  static const BoxDecoration tableBody = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.tableBottom,
    boxShadow: AppShadows.tableBody,
  );

  static const BoxDecoration editActionBtn = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.actionIcon,
  );

  static const BoxDecoration deleteActionBtn = BoxDecoration(
    color: AppColors.redXLight,
    borderRadius: AppRadius.actionIcon,
  );

  static const BoxDecoration infoIconBadge = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.iconBadge,
  );

  static const BoxDecoration stockCardIconBadge = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.stockChip,
  );

  static BoxDecoration stockChip({required Color accentColor}) => BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.chip,
    border: Border(top: BorderSide(color: accentColor, width: 3)),
    boxShadow: AppShadows.chip,
  );

  static const BoxDecoration acceptBtn = BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppRadius.inlineBtn,
  );

  static const BoxDecoration dateBadge = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.dateBadge,
  );

  static OutlineInputBorder formBorderEnabled = const OutlineInputBorder(
    borderRadius: AppRadius.formDropdown,
    borderSide: BorderSide(color: AppColors.border),
  );
  static OutlineInputBorder formBorderFocused = const OutlineInputBorder(
    borderRadius: AppRadius.formDropdown,
    borderSide: BorderSide(color: AppColors.primaryLight, width: 1.5),
  );

  static final BoxDecoration searchBar = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.searchBar,
    boxShadow: AppShadows.submitCard,
  );

  static BoxDecoration deliveryManCard({required Color accentColor}) => BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.deliveryManCard,
    border: Border(
      left: BorderSide(color: accentColor, width: AppSizes.deliveryCardAccentBorderWidth),
    ),
    boxShadow: AppShadows.submitCardLg,
  );

  static BoxDecoration deliveryManAvatar({required Color bgColor}) => BoxDecoration(
    color: bgColor,
    borderRadius: AppRadius.deliveryManAvatar,
  );

  static BoxDecoration statusPill({required Color bgColor}) => BoxDecoration(
    color: bgColor,
    borderRadius: AppRadius.statusPill,
  );

  static const BoxDecoration errorStateIcon = BoxDecoration(
    color: AppColors.redXLight,
    borderRadius: AppRadius.stateIconContainer,
  );

  static const BoxDecoration emptyStateIconBlue = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.stateIconContainer,
  );

  static const BoxDecoration sectionEmptyCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.deliveryManCard,
    boxShadow: AppShadows.submitCard,
  );

  static const BoxDecoration totalSaleCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.deliveryManCard,
    boxShadow: AppShadows.submitCardLg,
  );

  static const BoxDecoration totalSaleCardHeader = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.totalSaleCardTop,
  );

  static BoxDecoration heroHeaderIcon = BoxDecoration(
    color: Colors.white.withOpacity(0.16),
    borderRadius: AppRadius.heroIconContainer,
    border: Border.all(color: Colors.white.withOpacity(0.28), width: 1.5),
  );

  // ── ItemReturnXMI screens (NEW) ───────────────────
  /// XMI list card outer container.
  static const BoxDecoration xmiCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.xmiCard,
    boxShadow: AppShadows.card,
  );

  /// Vehicle icon badge inside XMI card header.
  static const BoxDecoration xmiVehicleIconBadge = BoxDecoration(
    color: AppColors.primaryXLight,
    borderRadius: AppRadius.xmiVehicleIconBadge,
  );

  /// Column header row background in the XMI item table.
  static const BoxDecoration xmiTableHeaderRow = BoxDecoration(
    color: AppColors.xmiTableHeaderBg,
  );

  /// Divider line inside XMI item table rows.
  static Border xmiRowDivider = const Border(
    bottom: BorderSide(color: AppColors.divider, width: 1),
  );

  // ── MoreOptionScreenGodownKeeper ─────────────────────────
  /// Menu card outer decoration (replaces inline BoxDecoration in _MenuCard).
  static const BoxDecoration moreOptionsMenuCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppRadius.moreOptionsMenuCard,
    boxShadow: AppShadows.moreOptionsMenuCard,
  );
}