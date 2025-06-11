import 'package:hive/hive.dart';

part 'source_model.g.dart';

@HiveType(typeId: 1)
class Source {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  Source({
    this.id,
    this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] ?? '',
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
