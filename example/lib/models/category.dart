class Category {
  final int? id;
  final String name;
  final String? icon;

  Category({this.id, required this.name, this.icon});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? ''),
        name: json['name']?.toString() ?? '',
        icon: json['icon']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        if (icon != null) 'icon': icon,
      };
}
