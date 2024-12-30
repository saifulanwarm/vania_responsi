import 'package:vania/vania.dart';
import 'package:backres/app/models/favorites.dart';

class FavoriteController extends Controller {
  Future<Response> create(Request req) async {
    req.validate({
      'id_user': 'required|string', // ID User harus diisi
      'id_resep': 'required|string', // ID Resep harus diisi
    }, {
      'id_user.required': 'ID User tidak boleh kosong',
      'id_user.string': 'ID User harus berupa teks',
      'id_resep.required': 'ID Resep tidak boleh kosong',
      'id_resep.string': 'ID Resep harus berupa teks',
    });

    final dataFavorite = req.input();
    dataFavorite['created_at'] = DateTime.now().toIso8601String();

    // Cek apakah kombinasi id_user dan id_resep sudah ada
    final existingFavorite = await Favorites()
        .query()
        .where('id_user', '=', dataFavorite['id_user'])
        .where('id_resep', '=', dataFavorite['id_resep'])
        .first();

    if (existingFavorite != null) {
      return Response.json({
        "message": "Resep ini sudah ada di daftar favorit Anda",
      }, 409);
    }

    // Simpan data favorit baru
    await Favorites().query().insert(dataFavorite);

    return Response.json(
      {
        "message": "Resep berhasil ditambahkan ke favorit",
        "data": dataFavorite,
      },
      200,
    );
  }

  Future<Response> show(String idUser) async {
    final favorites = await Favorites()
        .query()
        .where('id_user', '=', idUser)
        .get();

    return Response.json({
      'message': 'Berhasil mendapatkan daftar favorit',
      'data': favorites,
    }, 200);
  }

  Future<Response> destroy(String idUser, String idResep) async {
    try {
      // Cari data favorit berdasarkan id_user dan id_resep
      final favorite = await Favorites()
          .query()
          .where('id_user', '=', idUser)
          .where('id_resep', '=', idResep)
          .first();

      if (favorite == null) {
        return Response.json({
          'message': 'Data favorit tidak ditemukan',
        }, 404);
      }

      await Favorites()
          .query()
          .where('id_user', '=', idUser)
          .where('id_resep', '=', idResep)
          .delete();

      return Response.json({
        'message': 'Data favorit berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus data favorit',
      }, 500);
    }
  }
}

final FavoriteController favoriteController = FavoriteController();
