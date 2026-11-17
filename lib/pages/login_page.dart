import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Halaman login. Memakai StatefulWidget karena ada state yang berubah:
// tampil/sembunyi password dan status loading tombol.
class _LoginPageState extends State<LoginPage> {
  // Nama & logo aplikasi di halaman login (mudah diganti di sini)
  static const String _appName = 'Nexora Games';
  static const String _tagline = 'Temukan & mainkan game gratis';

  // Kunci untuk mengakses & memvalidasi Form
  final _formKey = GlobalKey<FormState>();
  // Controller untuk membaca teks yang diketik user
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _hidePass = true;
  bool _loading = false;

  // Controller wajib di-dispose agar tidak terjadi memory leak
  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  // Proses login: validasi form -> simpan ke SharedPreferences -> masuk ke MainPage
  Future<void> _login() async {
    // validate() menjalankan semua validator; kalau ada yang gagal, berhenti
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await AuthService.login(_emailC.text.trim(), _passC.text);
    // Setelah await, pastikan widget masih ada di layar sebelum memakai context
    if (!mounted) return;
    // pushReplacement: halaman login diganti, jadi tombol back tidak kembali ke login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }

  // Gaya TextField dipakai dua kali (email & password), jadi dibuat satu fungsi
  InputDecoration _decoration(String hint, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
      prefixIcon: Icon(icon, color: Colors.white70, size: 20),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C4DFF), Color(0xFF2D8CFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.rocket_launch_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 14),
                  const Text(_appName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text(_tagline,
                      style: TextStyle(fontSize: 12, color: Colors.white54)),
                  const SizedBox(height: 28),
                  // Input email dengan validasi sederhana
                  TextFormField(
                    controller: _emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _decoration('Email', Icons.email),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      if (!v.contains('@')) return 'Format email tidak valid';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  // Input password; obscureText menyembunyikan karakter,
                  // ikon mata di kanan untuk menampilkan/menyembunyikan
                  TextFormField(
                    controller: _passC,
                    obscureText: _hidePass,
                    decoration: _decoration(
                      'Password',
                      Icons.lock,
                      suffix: IconButton(
                        icon: Icon(
                          _hidePass ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white54,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _hidePass = !_hidePass),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Password tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      // onPressed null = tombol nonaktif (mencegah klik ganda saat loading)
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D8CFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
