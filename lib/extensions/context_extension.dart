import 'package:bots_demo/theme/themes/theme_cubit.dart';
import 'package:bots_demo/theme/themes/theme_palatte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ContextExtension on BuildContext {
  ThemePalatte get theme => read<ThemeCubit>().state;
}
