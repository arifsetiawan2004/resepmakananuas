import 'package:flutter/material.dart';
import 'package:resepmakanan/services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  AuthService _authService = AuthService();

  void _register(BuildContext context) async {
    try {
      final response = await _authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      // Tampilkan notifikasi pesan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"])),
      );

      if (response["status"]) {
        // Jika registrasi berhasil, arahkan kembali ke halaman login
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan. Silakan coba lagi.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Registrasi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(255, 113, 42, 1), // Warna oranye
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(255, 224, 179, 1), // Warna oranye muda
        child: ListView(
          children: [
            // Menambahkan logo di bagian atas
            Center(
              child: Image.asset(
                'assets/resepmasak.png', // Ganti dengan logo Anda
                width: 120,
                height: 120,
              ),
            ),
            SizedBox(height: 30),

            // Nama TextField
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama",
                labelStyle: TextStyle(
                    color: Color.fromRGBO(255, 113, 42, 1)), // Warna oranye
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1)), // Warna oranye
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1),
                      width: 2), // Warna oranye
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Email TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(
                    color: Color.fromRGBO(255, 113, 42, 1)), // Warna oranye
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1)), // Warna oranye
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1),
                      width: 2), // Warna oranye
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                    color: Color.fromRGBO(255, 113, 42, 1)), // Warna oranye
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1)), // Warna oranye
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1),
                      width: 2), // Warna oranye
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Tombol Register
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: Text("REGISTER", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromRGBO(255, 113, 42, 1), // Warna oranye
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Tombol Login
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                "Sudah punya akun? LOGIN di sini!",
                style: TextStyle(
                    color: Color.fromRGBO(255, 113, 42, 1),
                    fontSize: 16), // Warna oranye
              ),
            ),
          ],
        ),
      ),
    );
  }
}
