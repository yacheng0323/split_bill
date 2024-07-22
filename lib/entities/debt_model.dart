class DebtModel {
  String debtor; // 欠錢的人
  String creditor; // 收錢的人
  double amount; // 欠款金額

  DebtModel({
    required this.debtor,
    required this.creditor,
    required this.amount,
  });
}
