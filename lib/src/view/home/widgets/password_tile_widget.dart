import 'package:flutter/material.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';

class PasswordTileWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isFavorite;
  final VoidCallback onClickFunction;

  const PasswordTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isFavorite,
    required this.onClickFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: () => onClickFunction(),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: kLightDividerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      title.characters.first.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: kBlackColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (isFavorite)
                  Positioned(
                    child: Icon(
                      Icons.star,
                      color: kWarningColor,
                      size: 10.0,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: kMediumGreyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
