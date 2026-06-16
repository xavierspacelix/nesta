class MonthlyExpenses {
  const MonthlyExpenses({
    required this.year,
    required this.month,
    required this.rent,
    required this.wifi,
    required this.electricity,
    required this.waterCount,
    required this.fines,
  });

  final int year;
  final int month;
  final int rent;
  final int wifi;
  final int electricity;
  final int waterCount;
  final int fines;

  int get total => rent + wifi + electricity + fines;
}
