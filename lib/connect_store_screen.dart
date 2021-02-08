import 'package:bell_delivery_hub/components/Button.dart';
import 'package:bell_delivery_hub/globals/exveptions/login_error_modal.dart';
import 'package:bell_delivery_hub/globals/throttle.dart';
import 'package:bell_delivery_hub/login_bloc/login.dart';
import 'package:bell_delivery_hub/login_bloc/login_event.dart';
import 'package:bell_delivery_hub/network/urls.dart';
import 'package:bell_delivery_hub/utils/dependency_injection.dart';
import 'package:bell_delivery_hub/utils/theme.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:bell_delivery_hub/extensions/context_extension.dart';
import 'package:bell_delivery_hub/extensions/number_extensions.dart';
import 'authentication_bloc/authentication_bloc.dart';
import 'package:bell_delivery_hub/authentication_bloc/authentication_state.dart';

import 'login_bloc/login_bloc.dart';

class ConnectStoreScreen extends StatefulWidget {
  final BuildContext context;

  ConnectStoreScreen({Key key, this.context}) : super(key: key);

  @override
  _ConnectStoreScreenState createState() => _ConnectStoreScreenState();
}

class _ConnectStoreScreenState extends State<ConnectStoreScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController websiteUrlController = TextEditingController(text: "");
  TextEditingController consumerKeyController = TextEditingController(
      text: kReleaseMode ? "" : "ck_5fc6d72612a3cd3e6cacf7092f326750061d95d5");
  TextEditingController consumerSecretController = TextEditingController(
      text: kReleaseMode ? "" : "cs_640afce73058a9f256b6b03fb43f8519bdc37d11");

  FocusNode websiteUrlFocusNode = FocusNode();
  FocusNode consumerKeyFocusNode = FocusNode();
  FocusNode consumerSecretFocusNode = FocusNode();

  bool switchValue = true;
  bool passwordVisible = false;

  final String https = 'https://';

  String hintText = "";

  bool hasHint = true;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    websiteUrlController.dispose();
    consumerKeyController.dispose();
    consumerSecretController.dispose();
    websiteUrlFocusNode.dispose();
    consumerKeyFocusNode.dispose();
    consumerSecretFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: context.theme.surface,
        body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            cubit: inject<AuthenticationBloc>(),
            listener: (context, state) {},
            builder: (context, state) {
              return SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: context.theme.surface),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Arc(
                                arcType: ArcType.CONVEX,
                                edge: Edge.BOTTOM,
                                height: 100.flexibleHeight,
                                child: Container(
                                  height: 300.flexibleHeight,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            "assets/images/bg.png",
                                          ))),
                                  // child:
                                )),
                            Positioned(
                              // top: 50.flexibleHeight,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: 150.flexibleHeight,
                                alignment: Alignment(0.0, 2.5),
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/l.png"),
                                  radius: 50.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        60.verticalSpace,
                        Center(
                          child: Text("Welcome to BelaOryx",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: context.theme.textColor,
                                      fontSize: 25.flexibleFontSize,
                                      fontWeight: FontWeight.w600)),
                        ),
                        Center(
                          child: Text("www.belaoryx.com",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: context
                                          .theme.corePalatte.primaryColor,
                                      fontSize: 14.flexibleFontSize,
                                      fontWeight: FontWeight.normal)),
                        ),
                        20.verticalSpace,
                        consumerKey(),
                        20.verticalSpace,
                        consumerSecret(),
                        20.verticalSpace,
                        connectButton(state, context),
                        termsAndCondition(),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  termsAndCondition() {
    return SafeArea(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By connecting you agree to our ",
                  style: AppTextTheme.normal12Text.copyWith(
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      text: "Privacy policy",
                      style: AppTextTheme.normal12Text.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: " and ",
                      style: AppTextTheme.normal12Text.copyWith(
                          color: AppColors.greyColor,
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: "Terms and Conditions",
                      style: AppTextTheme.normal12Text.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.normal),
                    ),
                  ])),
        ),
      ),
    );
  }

  connectButton(AuthenticationState state, BuildContext context) {
    final _throttle = Throttling(duration: Duration(seconds: 2));

    return BlocConsumer<LoginBloc, LoginState>(
      cubit: inject<LoginBloc>(),
      listener: (ctx, loginState) {
//
        if (loginState is LoginFailure)
          ConnectStoreErrorModal.showErrorModal(
              isCustom: false, context: context, message: loginState.error);
        //
      },
      builder: (ctx, loginState) {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Button(
              isLoading: loginState is LoginLoading,
              message: "Login",
              style: AppTextTheme.normal15Text,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _throttle.throttle(() => inject<LoginBloc>().add(
                        LoginInWithEmailButtonPressed(
                          websiteUrl: baseUrl,
                          consumerKey: consumerKeyController.text,
                          consumerSecret: consumerSecretController.text,
                        ),
                      ));
                }

                // _showCupertinoAlert();
              },
            ));
      },
    );
  }

  consumerKey() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Consumer Key",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.flexibleFontSize)),
            ],
          ),
          6.verticalSpace,
          TextFormField(
            controller: consumerKeyController,
            focusNode: consumerKeyFocusNode,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.normal, fontSize: 15.flexibleFontSize),
            validator: (String value) {
              if (value.isEmpty) {
                return !switchValue
                    ? "username cannot be empty"
                    : 'consumer key cannot be empty.';
              } else if (switchValue &&
                  !value.toLowerCase().startsWith("ck_")) {
                return "Invalid consumer key format. ";
              } else
                return null;
            },
            inputFormatters: [FilteringTextInputFormatter.deny(" ")],
            onFieldSubmitted: (value) {
              consumerKeyFocusNode.unfocus();
              FocusScope.of(context).requestFocus(consumerSecretFocusNode);
            },
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Enter consumer key',
              hintStyle: AppTextTheme.normal15Text
                  .copyWith(color: AppColors.greyColor),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.theme.corePalatte.greyColor,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: AppColors.primaryColorAccent)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
            ),
          ),
        ],
      ),
    );
  }

  consumerSecret() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Consumer Secret",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.flexibleFontSize)),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          TextFormField(
            controller: consumerSecretController,
            focusNode: consumerSecretFocusNode,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.normal, fontSize: 15.flexibleFontSize),
            validator: (String value) {
              if (value.isEmpty) {
                return !switchValue
                    ? "Enter your application password"
                    : 'consumer secret cannot be empty.';
              } else if (switchValue &&
                  !value.toLowerCase().startsWith("cs_")) {
                return "Invalid consumer secret format.";
              } else if (!switchValue && value.length != 24) {
                return "Application password should be 24 character long..";
              } else
                return null;
            },
            onFieldSubmitted: (value) {
              consumerSecretFocusNode.unfocus();
            },
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.deny(" ")],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: switchValue ? false : !passwordVisible,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: AppColors.primaryColorAccent)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryColor)),
              hintText: 'Enter consumer secret',
              hintStyle: AppTextTheme.normal15Text
                  .copyWith(color: AppColors.greyColor),
            ),
          ),
        ],
      ),
    );
  }
}
