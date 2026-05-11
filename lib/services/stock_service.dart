import '../models/stock_model.dart';

class StockService {
  // Mock data for initial UI development, will simulate API fetch
  Future<List<Stock>> getStocks() async {
    // Simulating API response delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      // GOLD
      Stock(
        name: 'Emas Digital',
        symbol: 'GOLD',
        price: 1250450,
        change: 15200,
        changePercentage: 1.2,
        iconPath: 'assets/icon/financials/gold.png',
        category: 'Keuangan',
      ),
      // FINANCIALS
      Stock(
        name: 'Bank Central Asia',
        symbol: 'BBCA',
        price: 9850,
        change: 200,
        changePercentage: 2.1,
        iconPath: 'assets/icon/financials/bbca.png',
        category: 'Keuangan',
      ),
      Stock(
        name: 'Bank Rakyat Indonesia',
        symbol: 'BBRI',
        price: 5450,
        change: 65,
        changePercentage: 1.2,
        iconPath: 'assets/icon/financials/bbri.png',
        category: 'Keuangan',
      ),
      Stock(
        name: 'Bank Mandiri',
        symbol: 'BMRI',
        price: 6100,
        change: 50,
        changePercentage: 0.9,
        iconPath: 'assets/icon/financials/bmri.png',
        category: 'Keuangan',
      ),
      Stock(
        name: 'Bank Negara Indonesia',
        symbol: 'BBNI',
        price: 5200,
        change: 100,
        changePercentage: 1.9,
        iconPath: 'assets/icon/financials/bbni.png',
        category: 'Keuangan',
      ),
      Stock(
        name: 'Bank Jago',
        symbol: 'ARTO',
        price: 2450,
        change: -50,
        changePercentage: -2.0,
        iconPath: 'assets/icon/financials/arto.png',
        category: 'Keuangan',
      ),
      Stock(
        name: 'Bank Syariah Indonesia',
        symbol: 'BRIS',
        price: 2300,
        change: 40,
        changePercentage: 1.8,
        iconPath: 'assets/icon/financials/bris.png',
        category: 'Keuangan',
      ),
      Stock(
        name: 'KB Bank',
        symbol: 'BBKP',
        price: 80,
        change: 0,
        changePercentage: 0.0,
        iconPath: 'assets/icon/financials/bbkp.png',
        category: 'Keuangan',
      ),

      // ENERGY
      Stock(
        name: 'Adaro Minerals',
        symbol: 'ADMR',
        price: 1450,
        change: 30,
        changePercentage: 2.1,
        iconPath: 'assets/icon/energy/admr.png',
        category: 'Energi',
      ),
      Stock(
        name: 'Bumi Resources',
        symbol: 'BUMI',
        price: 155,
        change: 5,
        changePercentage: 3.3,
        iconPath: 'assets/icon/energy/bumi.png',
        category: 'Energi',
      ),
      Stock(
        name: 'Petrindo Jaya Kreasi',
        symbol: 'CUAN',
        price: 7200,
        change: -150,
        changePercentage: -2.0,
        iconPath: 'assets/icon/energy/cuan.png',
        category: 'Energi',
      ),
      Stock(
        name: 'Dian Swastatika',
        symbol: 'DSSA',
        price: 125000,
        change: 1200,
        changePercentage: 1.0,
        iconPath: 'assets/icon/energy/dssa.png',
        category: 'Energi',
      ),

      // INDUSTRIALS
      Stock(
        name: 'MNC Asia Holding',
        symbol: 'BHIT',
        price: 50,
        change: 0,
        changePercentage: 0.0,
        iconPath: 'assets/icon/industrials/bhit.png',
        category: 'Industri',
      ),
      Stock(
        name: 'Bakrie & Brothers',
        symbol: 'BNBR',
        price: 50,
        change: 0,
        changePercentage: 0.0,
        iconPath: 'assets/icon/industrials/bnbr.png',
        category: 'Industri',
      ),
      Stock(
        name: 'Impack Pratama',
        symbol: 'IMPC',
        price: 380,
        change: 10,
        changePercentage: 2.7,
        iconPath: 'assets/icon/industrials/impc.png',
        category: 'Industri',
      ),

      // INFRASTRUCTURES
      Stock(
        name: 'Telkom Indonesia',
        symbol: 'TLKM',
        price: 3850,
        change: -20,
        changePercentage: -0.5,
        iconPath: 'assets/icon/infrastructures/tlkm.png',
        category: 'Infrastruktur',
      ),
      Stock(
        name: 'Barito Renewables',
        symbol: 'BREN',
        price: 8500,
        change: 225,
        changePercentage: 2.7,
        iconPath: 'assets/icon/infrastructures/bren.png',
        category: 'Infrastruktur',
      ),
      Stock(
        name: 'Garuda Maintenance',
        symbol: 'GMFI',
        price: 160,
        change: 4,
        changePercentage: 2.5,
        iconPath: 'assets/icon/infrastructures/gmfi.png',
        category: 'Infrastruktur',
      ),
    ];
  }
}
