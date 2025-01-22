import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    var ingredients = recipe['ingredients'];
    if (ingredients is String) {
      ingredients = ingredients.split(',');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'],
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 113, 42, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  recipe['photo_url'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                recipe['title'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 113, 42, 1),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "by ${recipe['user']['name']}",
                style: TextStyle(fontSize: 16, color: Colors.orange[600]),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.orange),
              Text(
                "Deskripsi",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 113, 42, 1),
                ),
              ),
              SizedBox(height: 8),
              Text(
                recipe['description'] ?? 'Deskripsi tidak tersedia',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.orange),
              Text(
                "Bahan-Bahan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 113, 42, 1),
                ),
              ),
              SizedBox(height: 8),
              ingredients.isEmpty
                  ? Text("Bahan tidak tersedia",
                      style: TextStyle(fontSize: 16, color: Colors.black87))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        ingredients.length,
                        (index) => Text(
                          "- ${ingredients[index].trim()}",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ),
              SizedBox(height: 16),
              Divider(color: Colors.orange),
              Text(
                "Langkah-Langkah",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 113, 42, 1),
                ),
              ),
              SizedBox(height: 8),
              recipe['cooking_method'] == null ||
                      recipe['cooking_method'].isEmpty
                  ? Text("Langkah-langkah tidak tersedia",
                      style: TextStyle(fontSize: 16, color: Colors.black87))
                  : Text(
                      recipe['cooking_method'],
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
              SizedBox(height: 16),
              Divider(color: Colors.orange),
              Text(
                "Dibuat oleh ${recipe['user']['name']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 113, 42, 1),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thumb_up, color: Colors.orange[700]),
                      SizedBox(width: 4),
                      Text(
                        recipe['likes_count'].toString(),
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.comment, color: Colors.orange[300]),
                      SizedBox(width: 4),
                      Text(
                        recipe['comments_count'].toString(),
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
