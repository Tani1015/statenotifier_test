import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_model.freezed.dart';

@freezed
abstract class TagModel with _$TagModel {
  const factory TagModel({
    @Default("") String id,
    @Default("") String title,
  }) = _TagModel;
}