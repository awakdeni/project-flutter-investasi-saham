import 'package:flutter/material.dart';
import '../models/stock_model.dart';
import '../utils/app_colors.dart';

class MarketOverview extends StatelessWidget {
  final List<Stock> stocks;
  const MarketOverview({super.key, required this.stocks});

  @override
  Widget build(BuildContext context) {
    // Group stocks by category
    final Map<String, List<Stock>> categorizedStocks = {};
    for (var stock in stocks) {
      if (!categorizedStocks.containsKey(stock.category)) {
        categorizedStocks[stock.category] = [];
      }
      categorizedStocks[stock.category]!.add(stock);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Market Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...categorizedStocks.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryHeader(entry.key),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entry.value.length,
                  separatorBuilder: (context, index) => const Divider(color: AppColors.artboardDividerThin, height: 1),
                  itemBuilder: (context, index) {
                    final stock = entry.value[index];
                    return _buildStockListItem(stock);
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
          _buildCTA(),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    String emoji = '🏦';
    if (title == 'Teknologi') emoji = '💻';
    if (title == 'Infrastruktur') emoji = '🏗️';
    if (title == 'Energi') emoji = '⚡';
    if (title == 'Industri') emoji = '🏭';
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.artboardDividerThin,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildStockListItem(Stock stock) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.artboardBorder, width: 1),
      ),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.artboardDividerThin,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                stock.iconPath,
                width: 32,
                height: 32,
                errorBuilder: (_, __, ___) => const Icon(Icons.business, size: 32, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.symbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    stock.name,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${stock.change >= 0 ? '+' : ''}${stock.changePercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: stock.change >= 0 ? AppColors.greenDefault : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stock.price.toStringAsFixed(0),
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.greenDefault],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Mulai Investasi Sekarang',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buka akun saham Anda hanya dalam 5 menit.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Buka Akun', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
