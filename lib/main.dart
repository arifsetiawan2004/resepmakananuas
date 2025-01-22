import 'package:flutter/material.dart';
import 'package:resepmakanan/ui/home_screen.dart';
import 'package:resepmakanan/ui/login_screen.dart';
import 'package:resepmakanan/ui/register_screen.dart';
import 'package:resepmakanan/ui/detail_resep.dart';
import 'package:resepmakanan/ui/edit_resep.dart';
import 'package:resepmakanan/ui/tambah_resep.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: Menonaktifkan banner debug
      initialRoute:
          '/login', // Halaman pertama yang muncul saat aplikasi dibuka
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/tambah_resep': (context) => TambahScreen(), // Halaman tambah resep
      },
      onGenerateRoute: (settings) {
        // Menangani rute dengan data dinamis
        switch (settings.name) {
          case '/detail_resep':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: args['recipe']),
            );
          case '/edit_resep':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => EditScreen(
                recipeId: args['recipeId'],
                recipeData: args['recipeData'],
              ),
            );
          default:
            return null; // Rute tidak ditemukan
        }
      },
    );
  }
}
