import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../main.dart';
import '../../../utils/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String svgPath;
  final String? action;
  const CustomAppBar({super.key,
  required this.title,
  required this.svgPath,
  required this.action});

  @override
  Size get preferredSize => Size.fromHeight(AppHeights.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: AppHeights.appBarHeight,
      surfaceTintColor: Colors.transparent,
      leading: SvgPicture.asset(
        svgPath,
        colorFilter: ColorFilter.mode(
          appColors.textColor, // Optional: change SVG color
          BlendMode.srcIn,
        ),
      ),
      leadingWidth: AppWidths.appBarIconWidth, 
      centerTitle: true,// keep enough space
      
      title: Text(title, style: TextStyle(
        color: appColors.textColor,
        fontSize: AppFontsSizes.appBarTitleSize,
        fontWeight: FontWeight.w400
      ),),
      actions: [
        if(action != null)
        Text(action!)
      ],
    );
  }
}