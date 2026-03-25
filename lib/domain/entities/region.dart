class Region {
  final String code;
  final String name;
  final String? parentCode;
  final int level; // 1: 시도, 2: 시군구, 3: 읍면동
  final List<Region> children;

  const Region({
    required this.code,
    required this.name,
    this.parentCode,
    required this.level,
    this.children = const [],
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      code: json['code'] as String,
      name: json['name'] as String,
      parentCode: json['parentCode'] as String?,
      level: json['level'] as int,
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => Region.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'parentCode': parentCode,
      'level': level,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Region && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Region(code: $code, name: $name, level: $level)';
}
