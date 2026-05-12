import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FaqContent extends StatelessWidget {
  const FaqContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header FAQ dalam Bahasa Indonesia
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pertanyaan Populer',
                  style: TextStyle(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold, 
                    color: AppColors.textPrimary,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temukan jawaban atas pertanyaan yang paling sering diajukan pengguna Investden.',
                  style: TextStyle(
                    fontSize: 14, 
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Daftar FAQ
          _buildFaqItem(
            context,
            'Apa itu Investden?',
            'Investden adalah aplikasi pemantauan saham secara real-time yang membantu pengguna melihat pergerakan harga saham dengan cepat, mudah, dan akurat.',
          ),
          _buildFaqItem(
            context,
            'Apakah data saham diperbarui secara real-time?',
            'Ya, Investden dirancang untuk menampilkan data pasar dan pergerakan saham secara real-time agar pengguna dapat memantau market dengan lebih cepat.',
          ),
          _buildFaqItem(
            context,
            'Siapa saja yang bisa menggunakan Investden?',
            'Investden dapat digunakan oleh siapa saja, mulai dari investor pemula hingga trader aktif yang ingin memantau kondisi pasar saham dengan praktis.',
          ),
          _buildFaqItem(
            context,
            'Apakah Investden gratis digunakan?',
            'Sebagian fitur dapat digunakan secara gratis. Ke depannya, Investden dapat menghadirkan fitur premium untuk pengalaman monitoring yang lebih lengkap.',
          ),
          _buildFaqItem(
            context,
            'Apakah Investden menyediakan fitur analisis saham?',
            'Investden fokus pada pemantauan data saham dan market secara real-time. Fitur tambahan seperti analisis dan insight pasar dapat terus dikembangkan.',
          ),
          _buildFaqItem(
            context,
            'Apakah Investden aman digunakan?',
            'Kami berkomitmen menjaga keamanan dan kenyamanan pengguna dalam menggunakan platform Investden.',
          ),
          _buildFaqItem(
            context,
            'Apakah Investden tersedia di mobile?',
            'Ya, Investden dirancang agar dapat digunakan dengan nyaman melalui perangkat mobile maupun desktop.',
          ),
          _buildFaqItem(
            context,
            'Bagaimana cara mulai menggunakan Investden?',
            'Anda hanya perlu membuka platform Investden, lalu mulai memantau saham dan market favorit Anda secara langsung.',
          ),
          _buildFaqItem(
            context,
            'Apakah Investden memberikan rekomendasi investasi?',
            'Tidak. Investden menyediakan informasi dan data market untuk membantu pengguna melakukan analisis pribadi sebelum mengambil keputusan investasi.',
          ),
          _buildFaqItem(
            context,
            'Bagaimana cara menghubungi tim Investden?',
            'Anda dapat menghubungi tim kami melalui halaman kontak atau email resmi yang tersedia di platform Investden.',
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20), // Lebih membulat agar menyatu
        border: Border.all(color: Colors.black.withOpacity(0.03)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600, 
              fontSize: 15, 
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textTertiary,
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 0),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                answer,
                style: const TextStyle(
                  color: AppColors.textSecondary, 
                  height: 1.6, 
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
