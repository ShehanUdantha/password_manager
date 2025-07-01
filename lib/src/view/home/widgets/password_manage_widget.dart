import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/view/home/widgets/password_details_view_widget.dart';
import 'package:pass_key/src/view/home/widgets/password_update_widget.dart';

class PasswordManageWidget extends StatelessWidget {
  const PasswordManageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PasswordBloc, PasswordState>(
        buildWhen:
            (previous, current) =>
                previous.userSelectedPasswordModel != current.userSelectedPasswordModel ||
                previous.isEditMode != current.isEditMode,
        builder: (context, state) {
          final isItemSelected = state.userSelectedPasswordModel != null;

          final isEditMode = state.isEditMode;

          return isItemSelected
              ? SingleChildScrollView(
                child: isEditMode ? PasswordUpdateWidget() : PasswordDetailsViewWidget(),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.key_outlined,
                    color: kMediumGreyColor,
                    size: 50.0,
                  ),
                  Text(
                    context.loc.noItemSelected,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
        },
      ),
    );
  }
}
