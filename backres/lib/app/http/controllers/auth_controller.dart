import 'dart:io';
import 'package:vania/vania.dart';
import 'package:backres/app/models/user.dart';
// import 'package:uuid/uuid.dart'; // Tambahkan dependency uuid di pubspec.yaml

class AuthController extends Controller {
  // final Uuid uuid = Uuid(); // Inisialisasi UUID generator

  Future<Response> register(Request request) async {
    request.validate({
      'username': 'required',
      'email': 'required|email',
      'password': 'required|min_length:6|confirmed',
    }, {
      'username.required': 'nama tidak boleh kosong',
      'email.required': 'email tidak boleh kosong',
      'email.email': 'email tidak valid',
      'password.required': 'password tidak boleh kosong',
      'password.min_length': 'password harus terdiri dari minimal 6 karakter',
      'password.confirmed': 'konfirmasi password tidak sesuai',
    });

    final name = request.input('username');
    final email = request.input('email');
    var password = request.input('password');

    var user = await User().query().where('email', '=', email).first();
    if (user != null) {
      return Response.json({
        "message": "user sudah ada",
      }, 409);
    }

    password = Hash().make(password);
    await User().query().insert({
      "username": name,
      "email": email,
      "password": password,
      "created_at": DateTime.now().toIso8601String(),
    });

    return Response.json({
      "message": "berhasil mendaftarkan user",
    }, 201);
  }

  // Fungsi Login
  Future<Response> login(Request request) async {
    request.validate({
      'email': 'required|email',
      'password': 'required',
    }, {
      'email.required': 'email tidak boleh kosong',
      'email.email': 'email tidak valid',
      'password.required': 'password tidak boleh kosong',
    });

    final email = request.input('email');
    var password = request.input('password').toString();

    // Cek apakah pengguna dengan email tersebut ada
    var user = await User().query().where('email', '=', email).first();
    if (user == null) {
      return Response.json({
        "message": "user belum terdaftar",
      }, 409);
    }

    // Verifikasi password yang dimasukkan
    if (!Hash().verify(password, user['password'])) {
      return Response.json({
        "message": "kata sandi yang anda masukan salah",
      }, 401);
    }
    
    // Pastikan tokenable_id diatur ke id_user pengguna
    final token = await Auth()
        .login(user) // Pastikan `user` mengandung id_user yang benar
        .createToken(
          expiresIn: Duration(days: 30),
          withRefreshToken: true,
        );

    return Response.json({
      "message": "berhasil login",
      "token": token,
    });
  }

  // Fungsi Me (Profil Pengguna)
  Future<Response> me() async {
    Map? user = Auth().user();
    if (user != null) {
      user.remove('password'); // Hapus password dari respons
      return Response.json({
        "message": "success",
        "data": user,
      }, HttpStatus.ok);
    }
    return Response.json({
      "message": "success",
      "data": "",
    }, HttpStatus.notFound);
  }

  // Fungsi Update Password
  Future<Response> updatePassword(Request request) async {
    // Validasi input
    request.validate({
      'password': 'required|min_length:6',
    }, {
      'password.required': 'Password baru tidak boleh kosong',
      'password.min_length': 'Password harus terdiri dari minimal 6 karakter',
    });

    final password = request.input('password');
    var user = Auth().user();
    if (user == null) {
      return Response.json({
        "message": "Pengguna tidak ditemukan",
      }, 404);
    }

    // Hash password baru
    var hashedPassword = Hash().make(password);

    // Perbarui password di database
    await User().query().where('id', '=', user['id']).update({
      'password': hashedPassword,
      'updated_at': DateTime.now().toIso8601String(),
    });

    return Response.json({
      "message": "Password berhasil diperbarui",
    }, 200);
  }
}

final AuthController authController = AuthController();
