import 'package:vania/vania.dart';
import 'package:backres/app/models/user.dart';

class UserController extends Controller {
  Future<Response> create(Request req) async {
    req.validate({
      'image_url': 'String',
    }, {
      'image_url.required': 'image tidak boleh kosong',
      'image_url.string': 'image harus berupa teks',
    });

    final dataUser = req.input();
    dataUser['created_at'] = DateTime.now().toIso8601String();

    // Cek apakah username sudah ada
    final existingUser = await User()
        .query()
        .where('username', '=', dataUser['username'])
        .first();
    if (existingUser != null) {
      return Response.json({
        "message": "Foto sudah digunakan",
      }, 409);
    }

    // Simpan data user baru
    await User().query().insert(dataUser);

    return Response.json({
      "message": "Photo berhasil dibuat",
      "data": dataUser,
    }, 200);
  }

  Future<Response> show() async {
    final dataUser = await User().query().get();
    return Response.json({
      'message': 'Berhasil mengambil data',
      'data': dataUser,
    }, 200);
  }

  Future<Response> update(Request req, int id) async {
    req.validate({
      'image_url': 'String',
    }, {
      'image_url.required': 'image tidak boleh kosong',
      'image_url.string': 'image harus berupa teks',
    });

    final dataUser = req.input();
    dataUser['updated_at'] = DateTime.now().toIso8601String();

    final existingUser = await User().query().where('id', '=', id).first();
    if (existingUser == null) {
      return Response.json({
        "message": "User tidak ditemukan",
      }, 404);
    }

    // Update data user
    await User().query().where('id', '=', id).update(dataUser);

    return Response.json({
      "message": "User berhasil diperbarui",
      "data": dataUser,
    }, 200);
  }

  Future<Response> destroy(int id) async {
    try {
      final user = await User().query().where('id', '=', id).first();

      if (user == null) {
        return Response.json({
          'message': 'User dengan ID $id tidak ditemukan',
        }, 404);
      }

      await User().query().where('id', '=', id).delete();
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