import 'package:bell_delivery_hub/components/custom_shimmer.dart';
import 'package:bell_delivery_hub/modal/order/order.dart';
import 'package:bell_delivery_hub/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bell_delivery_hub/extensions/context_extension.dart';
import 'package:bell_delivery_hub/extensions/number_extensions.dart';

class OrderItem extends StatelessWidget {
  final String imageUrl;
  final String orderId;
  final String date;
  final Order data;

  final String amount;

  const OrderItem(
      {Key key, this.imageUrl, this.orderId, this.date, this.amount, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // return ExtendedNavigator.of(context).push(Routes.orderDetailsScreen,
        //     arguments:
        //         OrderDetailsScreenArguments(orderId: orderId, data: data));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: context.theme.surface,
          boxShadow: [
            BoxShadow(
              color: context.theme.themeType
                  ? context.theme.corePalatte.black
                  : Colors.grey[300].withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 15,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "${data.id} ${data.billing.firstName} ${data.billing.lastName}",
                          style: AppTextTheme.title.copyWith(
                              color: context.theme.textColor,
                              fontSize: 15.flexibleHeight)),
                      4.verticalSpace,
                      Text("${data.status}".toUpperCase(),
                          style: AppTextTheme.title.copyWith(
                              color: context.theme.corePalatte.greenColor,
                              fontSize: 15.flexibleHeight)),
                      8.verticalSpace,
                      Text(date,
                          style: AppTextTheme.title
                              .copyWith(fontSize: 15.flexibleFontSize)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(Icons.keyboard_arrow_right,
                      color: context.theme.corePalatte.greyColor,
                      size: 30.flexibleFontSize),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
