import 'package:flutter/material.dart';
import 'package:projek_bounty_hunter/models/candi.dart';
import 'package:projek_bounty_hunter/data/candi_data.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _builtController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _imageAssetController = TextEditingController();
  final TextEditingController _imageUrlsController = TextEditingController();

  Future<void> _addCandi() async {
    if (_formKey.currentState!.validate()) {
      String imageAsset = _imageAssetController.text.trim();
      String imageUrlsString = _imageUrlsController.text.trim();

      // Validasi URL gambar utama (imageAsset)
      if (imageAsset.isEmpty) {
        imageAsset = 'assets/images/default_image.png'; // Gambar default jika kosong
      }

      // Proses untuk imageUrls, split by koma jika ada lebih dari satu gambar
      List<String> imageUrls = imageUrlsString.isNotEmpty
          ? imageUrlsString.split(',').map((url) => url.trim()).toList()
          : [];

      final newCandi = Candi(
        name: _nameController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        built: _builtController.text,
        type: _typeController.text,
        imageAsset: imageAsset, // Gambar utama
        imageUrls: imageUrls, // Gambar-gambar tambahan untuk galeri
      );

      setState(() {
        candiList.add(newCandi);
      });

      // Menampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Candi berhasil ditambahkan!')),
      );

      // Menghapus form setelah pengiriman
      _clearForm();
    } else {
      // Menampilkan notifikasi kesalahan jika form tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tolong periksa data Anda')),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _locationController.clear();
    _descriptionController.clear();
    _builtController.clear();
    _typeController.clear();
    _imageAssetController.clear();
    _imageUrlsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Candi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nama Candi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama candi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Lokasi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _builtController,
                  decoration: const InputDecoration(labelText: 'Tahun Dibangun'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tahun dibangun tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Tipe Candi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tipe candi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                // Input untuk gambar utama (imageAsset)
                TextFormField(
                  controller: _imageAssetController,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar Utama (imageAsset)',
                    hintText: 'Masukkan URL gambar utama atau nama asset',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URL gambar utama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                // Input untuk gambar-gambar tambahan (imageUrls)
                TextFormField(
                  controller: _imageUrlsController,
                  decoration: const InputDecoration(
                    labelText: 'URL Gambar Galeri (pisahkan dengan koma)',
                    hintText: 'Misal: url1.com, url2.com, url3.com',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addCandi,
                  child: const Text('Tambah Candi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
