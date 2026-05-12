import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo atau Icon Header
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.rocket_launch_rounded, size: 60, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 32),

          // Teks Sambutan
          _buildSection(
            title: 'Selamat Datang di InvestDen',
            content: 'Platform pemantauan saham modern yang membantu Anda mengikuti pergerakan pasar secara real-time dengan cepat, mudah, dan akurat.',
          ),

          _buildSection(
            content: 'Kami hadir untuk memberikan pengalaman monitoring saham yang simpel namun powerful, sehingga investor pemula maupun trader aktif dapat memantau harga saham, pergerakan market, dan tren investasi kapan saja dan di mana saja.\n\nDengan teknologi real-time data monitoring, Investden membantu pengguna mendapatkan informasi pasar lebih cepat untuk mendukung pengambilan keputusan investasi yang lebih tepat.',
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.grey),
          const SizedBox(height: 24),

          // Visi
          _buildSection(
            title: 'Visi Kami',
            content: 'Menjadi platform pemantauan saham terpercaya yang memudahkan masyarakat Indonesia dalam mengakses informasi pasar finansial secara real-time.',
            icon: Icons.visibility_outlined,
          ),

          // Misi
          _buildSection(
            title: 'Misi Kami',
            content: '', 
            icon: Icons.assignment_outlined,
          ),
          _buildMisiItem('Menyediakan data saham yang cepat dan akurat'),
          _buildMisiItem('Membuat pengalaman investasi lebih mudah dipahami'),
          _buildMisiItem('Membantu pengguna memantau market secara efisien'),
          _buildMisiItem('Menghadirkan tampilan modern dan nyaman digunakan'),

          const SizedBox(height: 32),
          
          // Footer Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Text(
              'Investden percaya bahwa akses informasi finansial yang cepat adalah kunci dalam dunia investasi modern.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.w500, 
                fontStyle: FontStyle.italic,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection({String? title, required String content, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: AppColors.textPrimary
                  ),
                ),
              ],
            ),
          if (title != null) const SizedBox(height: 12),
          if (content.isNotEmpty)
            Text(
              content,
              style: const TextStyle(
                fontSize: 15, 
                color: AppColors.textSecondary, 
                height: 1.6
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMisiItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
