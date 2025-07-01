import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/services/encryption_service.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/view/home/widgets/hover_password_text_widget.dart';

class PasswordDetailsViewWidget extends StatelessWidget {
  const PasswordDetailsViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: (previous, current) => previous.userSelectedPasswordModel != current.userSelectedPasswordModel,
      builder: (context, state) {
        final userSelectedPasswordModel = state.userSelectedPasswordModel;

        final decryptedUserName = EncryptionService.decryptText(userSelectedPasswordModel?.userName ?? "");
        final decryptedPassword = EncryptionService.decryptText(userSelectedPasswordModel?.password ?? "");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: kLightDividerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          userSelectedPasswordModel?.label?.characters.first.toUpperCase() ?? "",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: kBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (userSelectedPasswordModel?.isFavorite ?? false)
                      Positioned(
                        child: Icon(
                          Icons.star,
                          color: kWarningColor,
                          size: 12.0,
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
                        userSelectedPasswordModel?.label ?? "",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        "${context.loc.lastModified} ${formatDateTimeWithTime(userSelectedPasswordModel?.updatedDate)}",
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
              ],
            ),
            Divider(
              height: height * 0.055,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.loc.userName,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: InkWell(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      onTap: () => _copyToClipboard(context, decryptedUserName),
                      child: Text(
                        decryptedUserName,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: height * 0.055,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.loc.password,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: InkWell(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      onTap: () => _copyToClipboard(context, decryptedPassword),
                      child: HoverPasswordTextWidget(
                        password: decryptedPassword,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: height * 0.055,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.loc.category,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      getCategoryLabelByKey(context, userSelectedPasswordModel?.category ?? "") ?? "",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: height * 0.055,
            ),
            SelectableText(
              cursorColor: kAppGreenColor,
              selectionColor: kAppGreenColor.withValues(alpha: 0.8),
              userSelectedPasswordModel?.notes ?? "",
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard(BuildContext context, String? value) {
    Clipboard.setData(ClipboardData(text: value ?? ""));
    showSnackBar(context, context.loc.copiedToClipBoard);
  }
}
