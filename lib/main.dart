import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'utils/app_colors.dart';
import 'models/stock_model.dart';
import 'services/stock_service.dart';
import 'widgets/horizontal_menu.dart';
import 'widgets/popular_stocks.dart';
import 'widgets/market_overview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/about_screen.dart'; 
import 'screens/faq_screen.dart'; // Import konten FAQ
import 'screens/news_screen.dart'; // Import konten Berita

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase removed
  await initializeDateFormatting('id_ID', null);
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const InvestDenApp());
}

class InvestDenApp extends StatelessWidget {
  const InvestDenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestDen',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
        },
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavIndex = 0;
  final StockService _stockService = StockService();
  // final AuthService _authService = AuthService(); // Hapus auth service
  String _selectedMenu = 'Beranda'; // Status menu aktif
  List<Stock> _stocks = [];
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Auto-refresh every 60 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final stocks = await _stockService.getStocks();
      if (mounted) {
        setState(() {
          _stocks = stocks;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error Loading Data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 65,
        title: Image.asset(
          'assets/gambar/logo.png',
          height: 35,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Text(
            'InvestDen',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        actions: [

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.neutral),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                const SizedBox(height: 16),
                // Menu Horizontal Tetap di Atas
                HorizontalMenu(
                  selectedMenu: _selectedMenu,
                  onMenuSelected: (menu) {
                    setState(() => _selectedMenu = menu);
                  },
                ),
                const SizedBox(height: 8),
                
                // Konten yang Berubah-ubah
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadData,
                    color: AppColors.primary,
                    child: _buildContent(),
                  ),
                ),
              ],
            ),

      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.swap_horiz, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  Widget _buildContent() {
    if (_selectedMenu == 'Tentang Kami') {
      return const AboutContent();
    }
    
    if (_selectedMenu == 'FAQ') {
      return const FaqContent();
    }
    
    if (_selectedMenu == 'Berita') {
      return const NewsContent();
    }
    
    // Default Dashboard Content
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Banner Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/gambar/header.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 48, color: AppColors.primary),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PopularStocks(stocks: _stocks.take(6).toList()),
          const SizedBox(height: 16),
          MarketOverview(stocks: _stocks),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomAppBar(
      color: AppColors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled, 'Beranda'),
            _buildNavItem(1, Icons.account_balance_wallet_outlined, 'Portofolio'),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(2, Icons.explore_outlined, 'Jelajah'),
            _buildNavItem(3, Icons.person_outline, 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textTertiary,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
