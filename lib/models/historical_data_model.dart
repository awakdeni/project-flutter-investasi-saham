class HistoricalDataPoint {
  final DateTime date;
  final double price;

  HistoricalDataPoint({
    required this.date,
    required this.price,
  });
}

class HistoricalPeriod {
  final String label; // "1 Bulan", "3 Bulan", "1 Tahun", "5 Tahun"
  final List<HistoricalDataPoint> data;
  final double changePercent;
  final double minPrice;
  final double maxPrice;

  HistoricalPeriod({
    required this.label,
    required this.data,
    required this.changePercent,
    required this.minPrice,
    required this.maxPrice,
  });
}
