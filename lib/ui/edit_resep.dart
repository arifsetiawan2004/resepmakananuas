import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:resepmakanan/services/session_service.dart';
import 'home_screen.dart';

class EditScreen extends StatefulWidget {
  final int recipeId;
  final Map<String, dynamic> recipeData;

  const EditScreen({
    super.key,
    required this.recipeId,
    required this.recipeData,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _cookingMethodController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final SessionService _sessionService = SessionService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.recipeData['title'];
    _cookingMethodController.text = widget.recipeData['cooking_method'];
    _ingredientsController.text = widget.recipeData['ingredients'];
    _descriptionController.text = widget.recipeData['description'];
  }

  Future<void> _updateRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token is invalid or expired.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final uri =
        Uri.parse("https://recipe.incube.id/api/recipes/${widget.recipeId}");
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'title': _titleController.text,
      'cooking_method': _cookingMethodController.text,
      'ingredients': _ingredientsController.text,
      'description': _descriptionController.text,
    });

    try {
      print("Sending PUT request to $uri");
      print("Headers: $headers");
      print("Body: $body");

      final response = await http
          .put(
        uri,
        headers: headers,
        body: body,
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            "The connection has timed out, please try again.");
      });

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if (response.statusCode == 422) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'] ?? 'Validation error')),
        );
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Failed to update recipe';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } on TimeoutException {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The connection has timed out, please try again.'),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cookingMethodController.dispose();
    _ingredientsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Resep'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 113, 42, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Judul Resep",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1),
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Judul tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1),
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Deskripsi tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Bahan-Bahan",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1),
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Bahan-bahan tidak boleh kosong'
                    : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cookingMethodController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Langkah Memasak",
                  labelStyle: TextStyle(color: Color.fromRGBO(255, 113, 42, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 113, 42, 1),
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Langkah memasak tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 113, 42, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _updateRecipe,
                        child: Text("Simpan Perubahan"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
