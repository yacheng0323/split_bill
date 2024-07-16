class GroupTableModel {
  final int? id;
  final String name;

  GroupTableModel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory GroupTableModel.fromMap(Map<String, dynamic> map) {
    return GroupTableModel(
      id: map['id'],
      name: map['name'],
    );
  }
}
