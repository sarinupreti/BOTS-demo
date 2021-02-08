import 'dart:convert';

import 'package:bell_delivery_hub/components/custom_alert.dart';
import 'package:bell_delivery_hub/components/qr_scanner/app_barcode_scanner_widget.dart';
import 'package:bell_delivery_hub/modal/qr_scanned_response.dart';
import 'package:bell_delivery_hub/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:bell_delivery_hub/extensions/context_extension.dart';
import 'package:bell_delivery_hub/extensions/number_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// FullScreenScannerPage
class QRScannerPage extends StatefulWidget {
  final String barcodeValue;

  const QRScannerPage({Key key, this.barcodeValue}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Barcode Scanner",
          style: AppTextTheme.appBarTitle.copyWith(
              fontSize: 17.flexibleFontSize, color: context.theme.textColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) async {
                if (code.trim() == widget.barcodeValue) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();

                  final data = QRScannedResponse(code, true);

                  if (!pref.containsKey(code)) {
                    setState(() {
                      pref.setStringList(code, [json.encode(data)]);
                    });
                  }

                  Navigator.pop(context, pref);

                  return CustomAlert.showCustomAlert(
                      context: context,
                      isSuccess: true,
                      message: "Barcode: $code does match with the product.",
                      title: "Barcode does match");

                  // return;
                } else {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();

                  final data = QRScannedResponse(widget.barcodeValue, false);

                  setState(() {
                    pref.setStringList(
                        widget.barcodeValue, [json.encode(data)]);
                  });
                  Navigator.pop(context, pref);

                  CustomAlert.showCustomAlert(
                      context: context,
                      isSuccess: false,
                      message:
                          "Barcode: $code does not match with the product.",
                      title: "Barcode does not match");

                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
