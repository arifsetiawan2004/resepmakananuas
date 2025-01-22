import 'package:flutter/material.dart';
import 'package:resepmakanan/services/auth_service.dart';
import 'package:resepmakanan/services/session_service.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthService _authService = AuthService();
  SessionService _sessionService = SessionService();

  void _login(context) async {
    try {
      final response = await _authService.login(
          _emailController.text, _passwordController.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response["message"])));
      if (response["status"]) {
        // nampil halaman home
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(255, 113, 42, 1), // Warna oranye
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Color.fromRGBO(255, 224, 179, 1),
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

            // Tombol Login
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text("LOGIN", style: TextStyle(fontSize: 16)),
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

            // Tombol Pendaftaran
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                "Belum punya akun? Daftar di sini!",
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
