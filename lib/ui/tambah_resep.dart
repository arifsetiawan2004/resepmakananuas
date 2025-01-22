import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:resepmakanan/services/session_service.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  _TambahScreenState createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _cookingMethodController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _photo;
  final SessionService _sessionService = SessionService();
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih Foto Dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitRecipe() async {
    if (_photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silahkan Pilih Foto')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final token = await _sessionService.getToken();
    final uri = Uri.parse("https://recipe.incube.id/api/recipes");
    final request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = _titleController.text
      ..fields['cooking_method'] = _cookingMethodController.text
      ..fields['ingredients'] = _ingredientsController.text
      ..fields['description'] = _descriptionController.text
      ..files.add(await http.MultipartFile.fromPath('photo', _photo!.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      Navigator.pop(context);
    } else if (response.statusCode == 422) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan resep')),
      );
    }
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
              _photo == null
                  ? const Text('Tidak Ada Gambar Yang Dipilih')
                  : Image.file(
                      _photo!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showImageSourceActionSheet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitRecipe,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.orange,
                        elevation: 4,
                      ),
                      child: const Text('Simpan Resep'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
