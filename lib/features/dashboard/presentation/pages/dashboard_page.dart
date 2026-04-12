import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apps_marketplace_integration_backend/features/auth/presentation/providers/auth_provider.dart';
import 'package:apps_marketplace_integration_backend/features/dashboard/presentation/providers/product_provider.dart';
import 'package:apps_marketplace_integration_backend/features/auth/presentation/pages/login_page.dart';
import 'package:apps_marketplace_integration_backend/features/auth/presentation/pages/verify_email_page.dart';

/// [AuthGuard] berfungsi sebagai gerbang keamanan.
/// Widget ini akan otomatis merender halaman Login, Verifikasi, atau Dashboard
/// berdasarkan perubahan status di AuthProvider.
class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Menggunakan watch agar widget rebuild otomatis saat status auth berubah
    final status = context.watch<AuthProvider>().status;

    return switch (status) {
      AuthStatus.authenticated => child,
      AuthStatus.emailNotVerified => const VerifyEmailPage(),
      _ => const LoginPage(), // Covers unauthenticated & initial
    };
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data setelah frame pertama dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductProvider>().fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final product = context.watch<ProductProvider>();

    // Membungkus seluruh Scaffold dengan AuthGuard
    return AuthGuard(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dashboard', style: TextStyle(fontSize: 18)),
              Text(
                'Halo, ${auth.firebaseUser?.displayName ?? 'User'}!',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Keluar',
              onPressed: () async {
                // Sesaat setelah fungsi ini selesai, AuthGuard akan mendeteksi
                // status berubah dan otomatis pindah ke LoginPage.
                await auth.logout();
              },
            ),
          ],
        ),
        body: _buildProductBody(product),
      ),
    );
  }

  /// Memisahkan logika body berdasarkan state produk (Clean UI)
  Widget _buildProductBody(ProductProvider product) {
    return switch (product.status) {
      // State: Loading atau Awal
      ProductStatus.loading || ProductStatus.initial => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat produk...'),
          ],
        ),
      ),

      // State: Terjadi Kesalahan
      ProductStatus.error => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                product.error ?? 'Terjadi kesalahan',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                onPressed: () => product.fetchProducts(),
              ),
            ],
          ),
        ),
      ),

      // State: Data Berhasil Dimuat
      ProductStatus.loaded => RefreshIndicator(
        onRefresh: () => product.fetchProducts(),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70, // Disesuaikan agar teks tidak terpotong
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: product.products.length,
          itemBuilder: (context, i) {
            final p = product.products[i];
            return _ProductCard(product: p);
          },
        ),
      ),
    };
  }
}

/// Widget kecil untuk kartu produk agar kode utama tidak terlalu panjang
class _ProductCard extends StatelessWidget {
  final dynamic product; // Gunakan ProductModel jika sudah di-import

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          Expanded(
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported, size: 40),
              ),
            ),
          ),
          // Info Produk
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Badge Kategori
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
