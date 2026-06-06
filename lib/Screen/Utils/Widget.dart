import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';
import 'package:lpgsalesandinventory/Screen/Utils/styles/app_spacing.dart';

import '../../newTheam/core/theme/app_colors.dart';
import 'Styling.dart';

Widget verticalDividerSmall() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 50.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}
Widget verticalDividerVerySmall() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 40.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}
Widget verticalDividerSmallest() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 20.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}

Widget verticalDividerSmallestRed() {
  return  Container(
    width: 2.0, // Width of the vertical line
    height: 15.0, // Height of the vertical line
    color: Colors.redAccent, // Color of the line
  );
}

Widget verticalDividerBig() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 50.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}
Widget verticalDividerVerySmallWidth() {
  return  Container(
    width: 0.4, // Width of the vertical line
    height: 40.0, // Height of the vertical line
    color: Colors.black, // Color of the line
  );
}
Widget myElevButton(BuildContext context, String title, VoidCallback callback) {
  return ElevatedButton(
    onPressed: callback,
    style: ButtonStyle(
      backgroundColor:
      MaterialStateProperty.all<Color>(Colors.blue),
    ),
    child: Text(title, style: Styling.buttonText),
  );
}

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon),
    hintText: hintText,
    hintStyle: Styling.hintText,
    contentPadding: EdgeInsets.symmetric(
        vertical: 1.15 * SizeConfig.heightMultiplier!,
        horizontal: 4.86 * SizeConfig.widthMultiplier!),
    /*enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade100, width: 0.0)),*/
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

Widget bodyTitleBlue(String title) {
  return Container(
    padding: const EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: const Color(0xff1280b3)),
        ),
        //titleText(title, 18, Colors.black),
      ],
    ),
  );
}

Widget textWidgetBlueColorWithStar(String title,String star) {
  return Container(
    margin: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Text(title, style: Styling.blueClrText,),
        Text(star, style: Styling.redStar,),
      ],
    ),

  );
}
Widget textWidgetBlueColorWithoutStar(String title) {
  return Container(
    margin: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Text(title, style: Styling.blueClrText,),
      ],
    ),

  );
}

Widget textWidgetBlueColorWithoutStarRed(String title) {
  return Container(
    margin: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Text(title, style: Styling.itemRedText,),
      ],
    ),

  );
}

Widget textWidgetBlueColorWithoutStarGreen(String title) {
  return Container(
    margin: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Text(title, style: Styling.itemGreenText,),
      ],
    ),

  );
}

Widget itemSubLine(String greyText, String blackText) {
  return Container(
    padding: EdgeInsets.only(
        left: 2.4 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child: Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.itemBlackTest,
          ),
        ),
      ],
    ),
  );
}

Widget itemSubLineLeftBig(String greyText, String blackText) {
  return Container(
    padding: EdgeInsets.only(
        left: 2.8 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child:
    Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.itemBlackTest,
          ),
        ),
      ],
    ),
  );
}

Widget itemSubLineWithBlackAndBlue(String greyText, String blackText) {
  return Container(
    padding: EdgeInsets.only(
        left: 2.4 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child: Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.bodyTitleWithBlue,
          ),
        ),
      ],
    ),
  );
}

Widget itemSubLineWithDD(String greyText, String blackText) {
  return
    Container(
    padding: EdgeInsets.only(
        left: 2.4 * SizeConfig.widthMultiplier!,
        right: 2.4 * SizeConfig.widthMultiplier!),
    child: Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            blackText,
            style: Styling.itemBlackTest,
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child:Icon(Icons.arrow_drop_down)
        ),
      ],
    ),
  );
}

InputDecoration buildInputBorderUpdateStatus(
    String hintText, BuildContext context) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: Styling.hintTextSmall,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade100, width: 0.0)),
      contentPadding: EdgeInsets.all(1.2 * SizeConfig.heightMultiplier!),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)));
}

InputDecoration buildInputBorderUpdateStatus1(
    String hintText,
    BuildContext context, {
      String? errorText, // ✅ add this
    }) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: Styling.hintTextSmall,
    errorText: errorText, // ✅ use here

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1.0,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.2,
      ),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.5,
      ),
    ),

    contentPadding: EdgeInsets.all(1.2 * SizeConfig.heightMultiplier!),
  );
}

InputDecoration buildInputBorderUpdateStatusMgr(
    String hintText, BuildContext context) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: Styling.hintTextSmall,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0)),
      contentPadding: EdgeInsets.all(1.2 * SizeConfig.heightMultiplier!),
      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
  );
}

InputDecoration buildInputWithoutBorderUpdateStatus(
    String hintText, BuildContext context) {
  return InputDecoration(
      hintText: hintText,
      enabledBorder: InputBorder.none,
      border: InputBorder.none);
}
InputDecoration buildInputWithSmallUnderline(BuildContext context) {
  return InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0), // Smaller underline
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 0.5), // Slightly thicker underline when focused
    ),
  );
}

Widget itemSubLineWithDDs(String greyText, bool isOutwardStockListViewVisible) {
  return
    Container(
      child:  Padding(
        padding: const EdgeInsets.all(10.0),
        child:
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              greyText,
              style: Styling.bodyTitleWithBlueHightSmallWithoutBold,
            ),
            Icon(
              isOutwardStockListViewVisible
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              size: 30, // Bigger icon for a more clickable feel
              color:Color(0xff1280b3),
            ),
          ],
        ),
      ),
    );

}

Widget itemSubLineWithDDss(String greyText, bool isImbalanceStockListViewVisible) {
  return
    Container(
      child:    Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              greyText,
              style: Styling.bodyTitleBig,
            ),
            Icon(
              isImbalanceStockListViewVisible
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              size: 30, // Bigger icon for a more clickable feel
              color:Color(0xff1280b3),
            ),
          ],
        ),
      ),
    );

}

Widget itemSubLineWithDDsss(String greyText,String textData, bool isImbalanceStockListViewVisible) {
  return
    Container(
      child:    Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.start,
              children: [
                Text(
                  greyText,
                  style: Styling.bodyTitleBig,
                ),
                Text(
                  textData,
                  style: Styling.itemBlackTestVerySmallReport,
                ),
              ],
            ),
            Icon(
              isImbalanceStockListViewVisible
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              size: 30, // Bigger icon for a more clickable feel
              color:Color(0xff1280b3),
            ),
          ],
        ),
      ),
    );

}

Widget itemSubLineSubMenu(String greyText, bool isImbalanceStockListViewVisible) {
  return
    Container(
      child:    Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(
              greyText,
              style: Styling.bodyTitleBig,
            ),
            Icon(
              isImbalanceStockListViewVisible
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              size: 24, // Bigger icon for a more clickable feel
              color:Color(0xff0d0e0e),
            ),
          ],
        ),
      ),
    );

}

Widget itemSubLineVehicle({
  required String greyText,
  String? blackText,
  Widget? valueWidget,
}) {
  return Container(
    padding: EdgeInsets.only(
      left: 2.4 * SizeConfig.widthMultiplier!,
      right: 2.4 * SizeConfig.widthMultiplier!,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: Text(
            greyText,
            style: Styling.itemGreyText,
          ),
        ),
        Text(
          " :  ",
          style: Styling.itemGreyText,
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: valueWidget ??
              Text(
                blackText ?? '',
                style: Styling.itemBlackTest,
              ),
        ),
      ],
    ),
  );
}

Widget countTextWidgetTextStarverysmall(BuildContext context, String label, {bool showAsterisk = false}) {

  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: label,
          style:Styling.itemBlackTestVerySmall,
        ),
        if (showAsterisk)
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red, // Asterisk in red
              fontSize: 8,
            ),
          ),
      ],
    ),
  );
}
Widget verticalDividerVerySmallBlue() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 40.0, // Height of the vertical line
    color: Color(0xFFfbe9e9), // Color of the line
  );
}
Widget verticalDividerVerySmallBluePink() {
  return  Container(
    width: 1.0, // Width of the vertical line
    height: 40.0, // Height of the vertical line
    color: Color(0xFFEFF2FB), // Color of the line
  );


}
class AppGradientSubmitButton extends StatelessWidget {
  const AppGradientSubmitButton({
    super.key,
    this.label = 'Submit',
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          splashColor: AppColors.blueXXL,
          child: Ink(
            decoration: BoxDecoration(
              gradient: isActive ? AppColors.gradPrimary : null,
              color: isActive ? null : AppColors.border,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive
                        ? Icons.check_circle_outline_rounded
                        : Icons.lock_outline_rounded,
                    color:
                    isActive ? Colors.white : AppColors.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                      color: isActive
                          ? Colors.white
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.label,
    this.dotColor,
    this.trailingButton,
  });

  final String label;
  final Color? dotColor;
  final Widget? trailingButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppSectionLabel(label: label, dotColor: dotColor),
        if (trailingButton != null) ...[
          const Spacer(),
          trailingButton!,
        ],
      ],
    );
  }
}
class AppAddItemButton extends StatelessWidget {
  const AppAddItemButton({
    super.key,
    this.label = 'Add Item',
    required this.isEnabled,
    required this.onTap,
  });

  final String label;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.blueXL : AppColors.bg2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
            isEnabled ? AppColors.blueXXL : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 16,
              color: isEnabled
                  ? AppColors.blueLight
                  : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppSpacing.seeAll.copyWith(
                color: isEnabled
                    ? AppColors.blueLight
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class AppDashCard extends StatelessWidget {
  const AppDashCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1E3A8A),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppGradientHeader extends StatelessWidget {
  const AppGradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.icon = Icons.receipt_long_rounded,
    this.logoPath, // 👈 Add this
    this.actions,
  });

  /// Main heading text.
  final String title;

  /// Smaller descriptive line shown below [title].
  final String subtitle;

  /// Icon displayed in the frosted badge next to the title.
  final IconData icon;
  final String? logoPath; // 👈 Add this


  /// Callback for the back-chevron button.
  final VoidCallback onBack;

  /// Optional action widgets shown on the right side.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.gradHero,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 20, 18),
          child: Row(
            children: [
              // ── Back chevron ────────────────────────────────────
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: 'Back',
              ),


              // Container(
              //   width: 42,
              //   height: 42,
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.15),
              //     borderRadius: BorderRadius.circular(13),
              //     border: Border.all(
              //       color: Colors.white.withOpacity(0.25),
              //       width: 1,
              //     ),
              //   ),
              //   child: Icon(
              //     icon,
              //     color: Colors.white,
              //     size: 22,
              //   ),
              // ),


              // ── Logo or Icon Badge ────────────────────────────────
              if (logoPath != null)
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                    logoPath!,
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              const SizedBox(width: 12),

              // ── Title + subtitle ────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Optional Actions ────────────────────────────────
              if (actions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
class AppItemDropdown extends StatelessWidget {
  const AppItemDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isRequired = true,
    this.prefixIcon,
  });

  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: label, style: AppSpacing.labelMD),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: AppColors.textMuted)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.blueLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0, horizontal: 12.0),
        filled: true,
        fillColor: AppColors.bg,
      ),
      items: items
          .map((name) => DropdownMenuItem<String>(
        value: name,
        child: Text(name, style: AppSpacing.dataRowLabel),
      ))
          .toList(),
      onChanged: onChanged,
      value: (value?.isEmpty ?? true) ? null : value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textMuted),
      dropdownColor: AppColors.white,
      style: AppSpacing.dataRowLabel,
    );
  }
}

class AppStyledField extends StatelessWidget {
  const AppStyledField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.enabled = true,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: AppSpacing.dataRowLabel,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label.replaceAll('*', ''),
                style: AppSpacing.labelMD,
              ),
              if (label.contains('*'))
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: AppColors.textMuted)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.blueLight, width: 1.5),
        ),
        filled: true,
        fillColor: enabled ? AppColors.bg : AppColors.bg2,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0, horizontal: 12.0),
        counterText: '',
      ),
    );
  }
}
class AppItemBadge extends StatelessWidget {
  const AppItemBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blueXL,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppSpacing.badgeText.copyWith(color: AppColors.blue),
      ),
    );
  }
}
class AppRemoveButton extends StatelessWidget {
  const AppRemoveButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.redXL,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.remove_rounded,
            color: AppColors.red, size: 18),
      ),
    );
  }
}

class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel({
    super.key,
    required this.label,
    this.dotColor,
  });

  final String label;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor ?? AppColors.blueLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label.toUpperCase(), style: AppSpacing.sectionHeaderq),
      ],
    );
  }
}


