import 'package:bell_delivery_hub/data/hive/hive_const.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'shipping.g.dart';

@HiveType(typeId: HIVE_SHIPPING_BOX_TYPE_ID)
@JsonSerializable()
// ignore: must_be_immutable
class Shipping extends HiveObject implements Equatable {
  @HiveField(0)
  String first_name;
  @HiveField(1)
  String last_name;
  @HiveField(2)
  String company;
  @HiveField(3)
  String address_1;
  @HiveField(4)
  String address_2;
  @HiveField(5)
  String city;
  @HiveField(6)
  String state;
  @HiveField(7)
  String postcode;
  @HiveField(8)
  String country;

  Shipping(
      {this.first_name,
      this.last_name,
      this.company,
      this.address_1,
      this.address_2,
      this.city,
      this.state,
      this.postcode,
      this.country});

  @override
  List<Object> get props => throw UnimplementedError();

  @override
  bool get stringify => throw UnimplementedError();

  static const fromJson = _$ShippingFromJson;

  Map<String, dynamic> toJson() => _$ShippingToJson(this);
}
