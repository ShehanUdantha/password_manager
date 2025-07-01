import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/theme/color_palette.dart';
import 'package:pass_key/src/core/utils/utils.dart';
import 'package:pass_key/src/view/home/home_left_side_view.dart';
import 'package:pass_key/src/view/home/home_right_side_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, state) {
          final isDarkMode = checkIsDarkMode(context, state.themeMode);

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: HomeLeftSideView(),
              ),
              Container(
                color: isDarkMode ? kDarkDividerColor : kLightDividerColor,
                width: 1.5,
              ),
              Expanded(
                flex: 5,
                child: HomeRightSideView(),
              ),
            ],
          );
        },
      ),
    );
  }
}
