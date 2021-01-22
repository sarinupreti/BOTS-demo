import 'package:bell_delivery_hub/data/hive/hive_const.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'meta.g.dart';

@HiveType(typeId: HIVE_META_BOX_TYPE_ID)
@JsonSerializable()
// ignore: must_be_immutable
class MetaData extends HiveObject implements Equatable {
  @HiveField(0)
  int id;
  @HiveField(1)
  String key;
  @HiveField(2)
  String value;

  MetaData({this.id, this.key, this.value});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool get stringify => throw UnimplementedError();
}
