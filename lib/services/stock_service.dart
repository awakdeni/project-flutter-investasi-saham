// VERSI OPTIMAL - PARALLEL LOADING
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/stock_model.dart';
import '../models/historical_data_model.dart';

class StockService {
  final String _chartBaseUrl =
      'https://query1.finance.yahoo.com/v8/finance/chart';
  final String _webProxy = 'https://api.allorigins.win/raw?url=';

  final Map<String, Map<String, String>> _stockMetadata = {
    'GC=F': {
      'name': 'Emas Antam',
      'cat': 'Keuangan',
      'icon': 'assets/icon/financials/gold.png',
    },
    'BBCA.JK': {
      'name': 'Bank Central Asia',
      'cat': 'Keuangan',
      'icon': 'assets/icon/financials/bbca.png',
    },
    'BBRI.JK': {
      'name': 'Bank Rakyat Indonesia',
      'cat': 'Keuangan',
      'icon': 'assets/icon/financials/bbri.png',
    },
    'BBNI.JK': {
      'name': 'Bank Negara Indonesia',
      'cat': 'Keuangan',
      'icon': 'assets/icon/financials/bbni.png',
    },
    'BMRI.JK': {
      'name': 'Bank Mandiri',
      'cat': 'Keuangan',
      'icon': 'assets/icon/financials/bmri.png',
    },
    'ADMR.JK': {
      'name': 'Adaro Minerals',
      'cat': 'Energi',
      'icon': 'assets/icon/energy/admr.png',
    },
    'BUMI.JK': {
      'name': 'Bumi Resources',
      'cat': 'Energi',
      'icon': 'assets/icon/energy/bumi.png',
    },
    'CUAN.JK': {
      'name': 'Petrindo Jaya Kreasi',
      'cat': 'Energi',
      'icon': 'assets/icon/energy/cuan.png',
    },
    'IMPC.JK': {
      'name': 'Impack Pratama',
      'cat': 'Industri',
      'icon': 'assets/icon/industrials/impc.png',
    },
    'TLKM.JK': {
      'name': 'Telkom Indonesia',
      'cat': 'Infrastruktur',
      'icon': 'assets/icon/infrastructures/tlkm.png',
    },
  };

  final Duration _requestTimeout = const Duration(seconds: 10);

  Uri _buildChartUri(String symbol) {
    final endpoint = '$_chartBaseUrl/$symbol?interval=1m&range=1d';
    return Uri.parse(
      kIsWeb ? '$_webProxy${Uri.encodeQueryComponent(endpoint)}' : endpoint,
    );
  }

  Future<Stock?> _fetchSingleStock(String symbol, double usdToIdr) async {
    try {
      final response = await http.get(_buildChartUri(symbol)).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meta = data['chart']['result'][0]['meta'];

        double price = (meta['regularMarketPrice'] as num).toDouble();
        double prevClose = (meta['previousClose'] as num).toDouble();

        if (symbol == 'GC=F') {
          price = (price / 31.1035) * usdToIdr;
          prevClose = (prevClose / 31.1035) * usdToIdr;
        }

        double change = price - prevClose;
        double changePercent = (change / prevClose) * 100;

        final metadata = _stockMetadata[symbol]!;

        return Stock(
          symbol: symbol == 'GC=F' ? 'GOLD' : symbol.replaceAll('.JK', ''),
          name: metadata['name']!,
          price: price,
          change: change,
          changePercentage: changePercent,
          category: metadata['cat']!,
          iconPath: metadata['icon']!,
        );
      }
    } catch (e) {
      debugPrint('Error fetching $symbol: $e');
    }
    return null;
  }

  Future<List<Stock>> getStocks() async {
    double usdToIdr = 16250.0;

    try {
      // 1. Get Exchange Rate
      try {
        final rateResponse = await http.get(_buildChartUri('IDR=X')).timeout(const Duration(seconds: 5));
        if (rateResponse.statusCode == 200) {
          final rateData = json.decode(rateResponse.body);
          usdToIdr = (rateData['chart']['result'][0]['meta']['regularMarketPrice'] as num).toDouble();
        }
      } catch (_) {}

      // 2. Fetch all stocks in PARALLEL
      final List<String> symbols = _stockMetadata.keys.toList();
      final List<Stock?> results = await Future.wait(
        symbols.map((symbol) => _fetchSingleStock(symbol, usdToIdr))
      );

      // 3. Filter out nulls and return
      return results.whereType<Stock>().toList();
    } catch (e) {
      debugPrint('StockService Global Error: $e');
      return [];
    }
  }

  Future<Map<String, HistoricalPeriod>> getHistoricalData(
    String symbol, {
    double? currentPrice,
  }) async {
    final Map<String, HistoricalPeriod> result = {};

    // Get USD to IDR exchange rate for emas conversion
    double usdToIdr = 16250.0;
    if (symbol == 'GOLD' || symbol == 'GC=F') {
      try {
        final rateResponse =
            await http.get(_buildChartUri('IDR=X')).timeout(const Duration(seconds: 5));
        if (rateResponse.statusCode == 200) {
          final rateData = json.decode(rateResponse.body);
          usdToIdr = (rateData['chart']['result'][0]['meta']['regularMarketPrice'] as num).toDouble();
        }
      } catch (_) {}
    }

    final periods = {
      '1 Bulan': {'range': '1mo', 'interval': '1d'},
      '3 Bulan': {'range': '3mo', 'interval': '1wk'},
      '1 Tahun': {'range': '1y', 'interval': '1mo'},
      '5 Tahun': {'range': '5y', 'interval': '3mo'},
    };

    // Map symbol ke format yang benar untuk Yahoo Finance
    String querySymbol = symbol;
    if (symbol == 'GOLD') {
      querySymbol = 'GC=F';
    } else if (!symbol.contains('.')) {
      // Tambah .JK jika belum ada (untuk saham Indonesia)
      querySymbol = '$symbol.JK';
    }

    debugPrint('Fetching historical data for $symbol (query: $querySymbol)');

    for (final entry in periods.entries) {
      try {
        final label = entry.key;
        final range = entry.value['range']!;
        final interval = entry.value['interval']!;

        final uri = Uri.parse(
          '$_chartBaseUrl/$querySymbol?range=$range&interval=$interval',
        );

        final response = await http.get(uri).timeout(_requestTimeout);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          
          // Check if response has error
          if (data['chart']['error'] != null) {
            debugPrint('Chart error for $querySymbol: ${data['chart']['error']}');
            continue;
          }

          if ((data['chart']['result'] as List).isEmpty) {
            debugPrint('No result data for $querySymbol');
            continue;
          }

          final resultData = data['chart']['result'][0];

          final timestamps = (resultData['timestamp'] as List).cast<int>();
          final quoteData = resultData['indicators']['quote'] as List;
          
          if (quoteData.isEmpty) {
            debugPrint('No quote data for $querySymbol');
            continue;
          }

          final closes = (quoteData[0]['close'] as List)
              .map((e) => e != null ? (e as num).toDouble() : null)
              .whereType<double>()
              .toList();

          if (timestamps.isEmpty || closes.isEmpty) {
            debugPrint('Empty timestamps or closes for $querySymbol');
            continue;
          }

          final dataPoints = <HistoricalDataPoint>[];
          for (int i = 0; i < timestamps.length && i < closes.length; i++) {
            double price = closes[i];
            
            // Convert from USD to IDR for emas
            if (querySymbol == 'GC=F') {
              // Yahoo returns price per troy ounce
              price = (price / 31.1035) * usdToIdr;
            }

            dataPoints.add(
              HistoricalDataPoint(
                date: DateTime.fromMillisecondsSinceEpoch(
                  timestamps[i] * 1000,
                ),
                price: price,
              ),
            );
          }

          if (dataPoints.isNotEmpty) {
            final minPrice =
                dataPoints.map((e) => e.price).reduce((a, b) => a < b ? a : b);
            final maxPrice =
                dataPoints.map((e) => e.price).reduce((a, b) => a > b ? a : b);

            final startPrice = dataPoints.first.price;
            final endPrice = dataPoints.last.price;
            final changePercent =
                ((endPrice - startPrice) / startPrice) * 100;

            // Validate data: jika currentPrice disediakan, pastikan dalam range yang reasonable
            if (currentPrice != null && currentPrice > 0) {
              // Harga historis seharusnya dalam range 50% - 200% dari current price untuk reasonable data
              if (maxPrice < currentPrice * 0.3 || minPrice > currentPrice * 3) {
                debugPrint(
                  'Warning: Suspicious historical data for $symbol. '
                  'CurrentPrice: $currentPrice, Historical range: $minPrice - $maxPrice',
                );
                continue;
              }
            }

            result[label] = HistoricalPeriod(
              label: label,
              data: dataPoints,
              changePercent: changePercent,
              minPrice: minPrice,
              maxPrice: maxPrice,
            );

            debugPrint(
              'Loaded $label data for $symbol: ${dataPoints.length} points, '
              'range: ${minPrice.toStringAsFixed(2)} - ${maxPrice.toStringAsFixed(2)}, '
              'change: ${changePercent.toStringAsFixed(2)}%',
            );
          }
        } else {
          debugPrint('HTTP error for $querySymbol: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching historical data for $symbol (${entry.key}): $e');
      }
    }

    if (result.isEmpty) {
      debugPrint('Warning: No historical data fetched for $symbol');
    }

    return result;
  }
}
