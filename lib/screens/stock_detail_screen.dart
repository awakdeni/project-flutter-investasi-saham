import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/stock_model.dart';
import '../models/historical_data_model.dart';
import '../services/stock_service.dart';
import '../utils/app_colors.dart';

class StockDetailScreen extends StatefulWidget {
  final Stock stock;

  const StockDetailScreen({super.key, required this.stock});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  final StockService _stockService = StockService();
  String _selectedPeriod = '1 Bulan';
  Map<String, HistoricalPeriod>? _historicalData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistoricalData();
  }

  Future<void> _loadHistoricalData() async {
    try {
      final data = await _stockService.getHistoricalData(
        widget.stock.symbol,
        currentPrice: widget.stock.price,
      );
      if (mounted) {
        setState(() {
          _historicalData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading historical data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.stock.symbol,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historicalData == null || _historicalData!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Data Historis Tidak Tersedia',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Gagal memuat data historis dari server. Periksa koneksi Anda.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _isLoading = true);
                          _loadHistoricalData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStockHeader(),
                      const SizedBox(height: 24),
                      _buildPeriodSelector(),
                      const SizedBox(height: 24),
                      _buildChart(),
                      const SizedBox(height: 24),
                      _buildStatistics(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStockHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
                  widget.stock.iconPath,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.business,
                    size: 28,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stock.symbol,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.stock.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Harga',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(widget.stock.price),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Perubahan',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        widget.stock.change >= 0
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 14,
                        color: widget.stock.change >= 0
                            ? AppColors.greenDefault
                            : Colors.redAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.stock.change >= 0 ? '+' : ''}${widget.stock.changePercentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.stock.change >= 0
                              ? AppColors.greenDefault
                              : Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['1 Bulan', '3 Bulan', '1 Tahun', '5 Tahun'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                    width: 1,
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart() {
    final data = _historicalData?[_selectedPeriod];
    if (data == null || data.data.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('Data tidak tersedia'),
        ),
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: ChartPainter(
          data: data.data,
          minPrice: data.minPrice,
          maxPrice: data.maxPrice,
          isPositive: data.changePercent >= 0,
        ),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildStatistics() {
    final data = _historicalData?[_selectedPeriod];
    if (data == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik $_selectedPeriod',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Harga Tertinggi',
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(data.maxPrice),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            'Harga Terendah',
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(data.minPrice),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            'Perubahan',
            '${data.changePercent >= 0 ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%',
            color: data.changePercent >= 0
                ? AppColors.greenDefault
                : Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<HistoricalDataPoint> data;
  final double minPrice;
  final double maxPrice;
  final bool isPositive;

  ChartPainter({
    required this.data,
    required this.minPrice,
    required this.maxPrice,
    required this.isPositive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = isPositive ? AppColors.greenDefault : Colors.redAccent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color =
          (isPositive ? AppColors.greenDefault : Colors.redAccent).withValues(
        alpha: 0.1,
      )
      ..style = PaintingStyle.fill;

    final priceRange = maxPrice - minPrice;
    if (priceRange == 0) return;

    // Calculate points
    final points = <Offset>[];
    final width = size.width;
    final height = size.height;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * width;
      final normalizedPrice = (data[i].price - minPrice) / priceRange;
      final y = height - (normalizedPrice * height);
      points.add(Offset(x, y));
    }

    // Draw fill
    final path = Path();
    path.moveTo(0, size.height);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, fillPaint);

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) => false;
}
