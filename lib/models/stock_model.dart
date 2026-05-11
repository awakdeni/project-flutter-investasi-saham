class Stock {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final double changePercentage;
  final String iconPath;
  final String category;

  Stock({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercentage,
    required this.iconPath,
    required this.category,
  });

  factory Stock.fromJson(Map<String, dynamic> json, String category, String iconPath) {
    return Stock(
      name: json['shortName'] ?? json['symbol'],
      symbol: json['symbol'],
      price: (json['regularMarketPrice'] as num).toDouble(),
      change: (json['regularMarketChange'] as num).toDouble(),
      changePercentage: (json['regularMarketChangePercent'] as num).toDouble(),
      iconPath: iconPath,
      category: category,
    );
  }
}
