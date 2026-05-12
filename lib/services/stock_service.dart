// VERSI BERSIH - TANPA PRINT
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/stock_model.dart';

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

  final Duration _requestTimeout = const Duration(seconds: 12);

  Uri _buildChartUri(String symbol) {
    final endpoint = '$_chartBaseUrl/$symbol?interval=1m&range=1d';
    return Uri.parse(
      kIsWeb ? '$_webProxy${Uri.encodeQueryComponent(endpoint)}' : endpoint,
    );
  }

  Future<http.Response> _getChartResponse(Uri uri) {
    return http
        .get(uri)
        .timeout(_requestTimeout, onTimeout: () => http.Response('', 408));
  }

  Future<List<Stock>> getStocks() async {
    List<Stock> stocks = [];
    double usdToIdr = 16250.0;

    try {
      try {
        final rateResponse = await _getChartResponse(_buildChartUri('IDR=X'));
        if (rateResponse.statusCode == 200) {
          final rateData = json.decode(rateResponse.body);
          usdToIdr =
              (rateData['chart']['result'][0]['meta']['regularMarketPrice']
                      as num)
                  .toDouble();
        }
      } catch (_) {}

      final List<String> symbols = _stockMetadata.keys.toList();
      for (var symbol in symbols) {
        try {
          final response = await _getChartResponse(_buildChartUri(symbol));

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

            stocks.add(
              Stock(
                symbol: symbol == 'GC=F'
                    ? 'GOLD'
                    : symbol.replaceAll('.JK', ''),
                name: metadata['name']!,
                price: price,
                change: change,
                changePercentage: changePercent,
                category: metadata['cat']!,
                iconPath: metadata['icon']!,
              ),
            );
          }
        } catch (e) {
          // Menggunakan debugPrint sesuai standar
          debugPrint('Error: $e');
        }
      }

      return stocks;
    } catch (e) {
      // Menggunakan debugPrint sesuai standar
      debugPrint('StockService Error: $e');
      return [];
    }
  }
}
