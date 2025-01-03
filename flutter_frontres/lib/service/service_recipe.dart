import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://192.168.136.11:8000/api';

Future<bool> createRecipe(int idResep, String title, String deskripsiBahan, String deskripsiInstruksi, String maker, String urlImage, int idCategory) async {
  final url = Uri.parse('$baseUrl/tambah-resep'); // Pastikan URL ini benar

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_resep': idResep,  // Pastikan id_resep diberikan sebagai integer
        'title': title,
        'deskripsi_bahan': deskripsiBahan,
        'deskripsi_instruksi': deskripsiInstruksi,
        'maker': maker,
        'url_image': urlImage,  // url_image harus diberikan (tidak nullable)
        'id_category': idCategory,
      }),
    );

    // Debugging respons API
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Memeriksa status code 200 atau 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);

      // Debugging: cek key response
      print('Response Data: $responseData');

      if (responseData['message'] != null && responseData['message'] == 'Resep berhasil ditambahkan') {
        // Resep berhasil ditambahkan
        return true;
      } else {
        // Jika tidak ada pesan yang sesuai meskipun status code 201
        print('Gagal menambahkan resep: ${responseData['message']}');
        return false;
      }
    } else {
      // Status code bukan 200 atau 201
      print('Error: Status Code ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error saat menambahkan resep: $e');
    return false;
  }
}
