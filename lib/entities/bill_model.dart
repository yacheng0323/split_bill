class BillModel {
  final int? id;
  final String title;
  final int dateTime;
  final double money;
  final String paidBy;
  final int? tableId;

  BillModel({
    this.id,
    required this.title,
    required this.dateTime,
    required this.money,
    required this.paidBy,
    this.tableId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime,
      'money': money,
      'paidBy': paidBy,
      'tableId': tableId,
    };
  }

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      title: map['title'],
      dateTime: map['dateTime'],
      money: map['money'],
      paidBy: map['paidBy'],
      tableId: map['tableId'],
    );
  }
}
