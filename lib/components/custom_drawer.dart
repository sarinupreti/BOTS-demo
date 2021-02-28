import 'package:bots_demo/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:bots_demo/blocs/authentication_bloc/authentication_event.dart';
import 'package:bots_demo/utils/dependency_injection.dart';
import 'package:clippy_flutter/trapezoid.dart';
import 'package:flutter/material.dart';
import 'package:bots_demo/extensions/number_extensions.dart';
import 'package:bots_demo/extensions/context_extension.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
    @required this.screenWidth,
  }) : super(key: key);

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: context.theme.themeType
            ? context.theme.surface
            : context.theme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150.flexibleHeight,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              scale: 0.5,
                              alignment: Alignment.topCenter,
                              image: AssetImage(
                                "assets/images/bots_logo.png",
                              ))),
                      // child:
                    ),
                    Positioned(
                      left: 20.flexibleHeight,
                      bottom: 10,
                      child: Container(
                        height: 100.flexibleHeight,
                        alignment: Alignment(0.0, 2.5),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/images/l.png"),
                          radius: 30.0,
                        ),
                      ),
                    ),
                  ],
                ),
                50.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text("Welcome to BOTS DEMO",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: context.theme.textColor,
                          fontSize: 16.flexibleFontSize,
                          fontWeight: FontWeight.w600)),
                ),
                ListTile(
                  title: Text(
                    "Welcome to BOTS DEMO",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: context.theme.textColor,
                        fontSize: 16.flexibleFontSize,
                        fontWeight: FontWeight.w600),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
            InkWell(
              onTap: () {
                return inject<AuthenticationBloc>().add(UserLoggedOut());
              },
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Sign out",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: context.theme.corePalatte.errorColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
