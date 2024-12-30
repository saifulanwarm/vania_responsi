import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

const String baseUrl ='http://192.168.100.69:8000/api'; 
// Fungsi untuk register user
Future<void> register(String username, String email, String password, String passwordConfirmation) async {
  final url = Uri.parse('$baseUrl/auth/register'); // Endpoint untuk register

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation, // Menyertakan konfirmasi password
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      print('User registered successfully: ${data['message']}');
    } else {
      final error = json.decode(response.body);
      throw Exception('Register failed: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Register failed: $e');
  }
}

// Fungsi login
Future<void> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/auth/login');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['token']['access_token'];

      await secureStorage.write(key: 'access_token', value: accessToken);
      print('Access token successfully stored!');
    } else {
      final error = json.decode(response.body);
      throw Exception('Login failed: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Login failed: $e');
  }
}

// Fungsi untuk update password
Future<void> updatePassword(String password) async {
  final url = Uri.parse('$baseUrl/user/update-password'); // Endpoint untuk update password
  final accessToken = await secureStorage.read(key: 'access_token'); // Ambil token akses dari storage
  
  // Tambahkan log untuk memastikan token yang dibaca benar
  print('Access Token: $accessToken'); 

  if (accessToken == null) {
    throw Exception('Token tidak ditemukan, silakan login kembali');
  }

  try {
    // Mengirimkan request PATCH untuk update password
    final response = await http.patch( // Ubah ke .patch
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Mengirimkan token untuk autentikasi
      },
      body: json.encode({
        'password': password, // Kata sandi baru yang ingin diubah
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Password berhasil diperbarui: ${data['message']}');
    } else {
      final error = json.decode(response.body);
      throw Exception('Gagal memperbarui password: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Update password gagal: $e');
  }
}

// Fungsi untuk mengambil data protected
Future<Map<String, dynamic>> fetchProtectedData() async {
  final url = Uri.parse('$baseUrl/me');
  final accessToken = await secureStorage.read(key: 'access_token');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Data fetched successfully: $data');
      return data; // Return the parsed data
    } else if (response.statusCode == 401) {
      throw Exception('Invalid or expired access token. Please log in again.');
    } else {
      final error = json.decode(response.body);
      throw Exception('Error: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('An error occurred: $e');
  }
}

Future<bool> createCategory(int idCategory, String name, String description) async {
  final url = Uri.parse('$baseUrl/add-category'); // Pastikan URL ini benar

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id_category': idCategory,
        'name': name,
        'description': description,
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

      if (responseData['message'] != null && responseData['message'] == 'Kategori berhasil ditambahkan') {
        // Kategori berhasil ditambahkan
        return true;
      } else {
        // Jika tidak ada pesan yang sesuai meskipun status code 201
        print('Gagal menambahkan kategori: ${responseData['message']}');
        return false;
      }
    } else {
      // Status code bukan 200 atau 201
      print('Error: Status Code ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error saat menambahkan kategori: $e');
    return false;
  }
}



// Fungsi untuk menampilkan semua kategori
Future<List<dynamic>> fetchCategories() async {
  final url = Uri.parse('$baseUrl/list-category'); // Endpoint untuk semua kategori

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Pastikan data ini sesuai dengan respons backend Anda
    } else {
      final error = json.decode(response.body);
      throw Exception('Error: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Error saat mengambil kategori: $e');
  }
}

// Fungsi untuk menampilkan kategori berdasarkan ID
Future<Map<String, dynamic>> fetchCategoryById(int idCategory) async {
  final url = Uri.parse('$baseUrl/daftar-category/$idCategory'); // Endpoint untuk kategori berdasarkan ID

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Pastikan data ini sesuai dengan respons backend Anda
    } else {
      final error = json.decode(response.body);
      throw Exception('Error: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Error saat mengambil kategori: $e');
  }
}

// Fungsi untuk mengupdate kategori berdasarkan ID
Future<void> updateCategory(int idCategory, String name, String description) async {
  final url = Uri.parse('$baseUrl/edit-category/$idCategory'); // Endpoint untuk mengupdate kategori

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      print('Kategori berhasil diperbarui!');
    } else {
      final error = json.decode(response.body);
      throw Exception('Gagal memperbarui kategori: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Error memperbarui kategori: $e');
  }
}

// Fungsi untuk menghapus kategori berdasarkan ID
Future<void> deleteCategory(int idCategory) async {
  final url = Uri.parse('$baseUrl/hapus-category/$idCategory'); // Endpoint untuk menghapus kategori

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Kategori berhasil dihapus!');
    } else {
      final error = json.decode(response.body);
      throw Exception('Gagal menghapus kategori: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Error menghapus kategori: $e');
  }
}

// Fungsi logout
Future<void> logout() async {
  await secureStorage.delete(key: 'access_token');
  print('Access token successfully deleted.');
}
