import 'dart:ffi';
import 'package:backres/app/models/user.dart';
import 'package:vania/vania.dart';

class UserController extends Controller {
  Future<Response> create(Request req) async {
    req.validate({
      'username': 'required|String', // Username yang harus diisi
      'email': 'required|email', // Email yang harus diisi dan valid
      'password': 'required', // Password harus diisi
    }, {
      'username.required': 'Username tidak boleh kosong',
      'username.string': 'Username harus berupa teks',
      'email.required': 'Email tidak boleh kosong',
      'email.email': 'Email tidak valid',
      'password.required': 'Password tidak boleh kosong',
    });

    final dataUser = req.input();
    dataUser['created_at'] = DateTime.now().toIso8601String();

    // Cek apakah username atau email sudah ada
    final existingUser = await User().query().where('username', '=', dataUser['username']).orWhere('email', '=', dataUser['email']).first();
    if (existingUser != null) {
      return Response.json({
        "message": "Username atau email sudah ada",
      }, 409);
    }

    // Simpan data user baru
    await User().query().insert(dataUser);

    return Response.json(
      {
        "message": "Success",
        "data": dataUser,
      },
      200,
    );
  }

  Future<Response> show() async {
    final dataUser = await User().query().get();
    return Response.json({
      'message': 'Success',
      'data': dataUser,
    }, 200);
  }

  Future<Response> update(Request req, Char id) async {
    req.validate({
      'username': 'required|String', // Username yang harus diisi
      'email': 'required|email', // Email yang harus diisi dan valid
      'password': 'required', // Password harus diisi
    }, {
      'username.required': 'Username tidak boleh kosong',
      'username.string': 'Username harus berupa teks',
      'email.required': 'Email tidak boleh kosong',
      'email.email': 'Email tidak valid',
      'password.required': 'Password tidak boleh kosong',
    });

    final dataUser = req.input();
    dataUser['updated_at'] = DateTime.now().toIso8601String();

    final existingUser = await User()
        .query()
        .where('id_user', '=', id) // Pastikan menggunakan 'id_user' di sini
        .first();

    if (existingUser == null) {
      return Response.json({
        "message": "User tidak ditemukan",
      }, 404);
    }

    await User()
        .query()
        .where('id_user', '=', id) // Pastikan menggunakan 'id_user' untuk update
        .update(dataUser);

    return Response.json({
      "message": "User berhasil diperbarui",
      "data": dataUser,
    }, 200);
  }

  Future<Response> destroy(Char id) async {
    try {
      final user = await User().query().where('id_user', '=', id).first();

      if (user == null) {
        return Response.json({
          'message': 'User dengan ID $id tidak ditemukan',
        }, 404);
      }

      await User().query().where('id_user', '=', id).delete();
      return Response.json({
        'message': 'User berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus user',
      }, 500);
    }
  }
}

final UserController userController = UserController();
