import 'package:flutter/material.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';

class ThemeAndLanguageTileWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onClickFunction;

  const ThemeAndLanguageTileWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onClickFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: () => onClickFunction(),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.radio_button_checked_outlined,
                color: kAppGreenColor,
                size: 18.0,
              ),
          ],
        ),
      ),
    );
  }
}
