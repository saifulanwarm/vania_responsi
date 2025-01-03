import 'package:vania/vania.dart';
import 'package:backres/app/models/recipes.dart';

class RecipeController extends Controller {

  // Menambahkan resep baru dengan id_resep manual (id_resep sebagai integer)
  Future<Response> create(Request req) async {
    req.validate({
      'id_resep': 'required|integer', // ID resep harus diisi sebagai integer
      'title': 'required|string', // Judul resep harus diisi
      'deskripsi_bahan': 'required|string', // Deskripsi bahan harus diisi
      'deskripsi_instruksi': 'required|string', // Deskripsi instruksi harus diisi
      'maker': 'required|string', // Pembuat resep harus diisi
      'id_category': 'required|integer', // ID kategori harus diisi sebagai integer
      'url_image': 'nullable|string', // URL gambar opsional
    }, {
      'id_resep.required': 'ID resep tidak boleh kosong',
      'id_resep.integer': 'ID resep harus berupa angka',
      'title.required': 'Judul resep tidak boleh kosong',
      'title.string': 'Judul resep harus berupa teks',
      'deskripsi_bahan.required': 'Deskripsi bahan tidak boleh kosong',
      'deskripsi_bahan.string': 'Deskripsi bahan harus berupa teks',
      'deskripsi_instruksi.required': 'Deskripsi instruksi tidak boleh kosong',
      'deskripsi_instruksi.string': 'Deskripsi instruksi harus berupa teks',
      'maker.required': 'Pembuat resep tidak boleh kosong',
      'maker.string': 'Pembuat resep harus berupa teks',
      'id_category.required': 'ID kategori tidak boleh kosong',
      'id_category.integer': 'ID kategori harus berupa angka',
      'url_image.string': 'URL gambar harus berupa teks',
    });
    

    final dataRecipe = req.input();
    dataRecipe['created_at'] = DateTime.now().toIso8601String();
    dataRecipe['updated_at'] = DateTime.now().toIso8601String();

    // Cek apakah resep dengan ID yang sama sudah ada
    final existingRecipe = await Recipes()
        .query()
        .where('id_resep', '=', dataRecipe['id_resep'])
        .first();

    if (existingRecipe != null) {
      return Response.json({
        "message": "Resep dengan ID ini sudah ada",
      }, 409);
    }

    // Simpan resep baru
    await Recipes().query().insert(dataRecipe);

    return Response.json(
      {
        "message": "Resep berhasil ditambahkan",
        "data": dataRecipe,
      },
      200,
    );
  }

  // Menampilkan resep berdasarkan ID (id_resep sebagai integer)
  Future<Response> show(int idResep) async {
    final recipe = await Recipes()
        .query()
        .where('id_resep', '=', idResep)
        .first();

    if (recipe == null) {
      return Response.json({
        'message': 'Resep tidak ditemukan',
      }, 404);
    }

    return Response.json({
      'message': 'Berhasil mendapatkan resep',
      'data': recipe,
    }, 200);
  }

  // Mengupdate resep berdasarkan ID (id_resep sebagai integer)
  Future<Response> update(Request req, int idResep) async {
    req.validate({
      'title': 'required|string', // Judul resep harus diisi
      'deskripsi_bahan': 'required|string', // Deskripsi bahan harus diisi
      'deskripsi_instruksi': 'required|string', // Deskripsi instruksi harus diisi
      'url_image': 'nullable|string', // URL gambar opsional
    }, {
      'title.required': 'Judul resep tidak boleh kosong',
      'title.string': 'Judul resep harus berupa teks',
      'deskripsi_bahan.required': 'Deskripsi bahan tidak boleh kosong',
      'deskripsi_bahan.string': 'Deskripsi bahan harus berupa teks',
      'deskripsi_instruksi.required': 'Deskripsi instruksi tidak boleh kosong',
      'deskripsi_instruksi.string': 'Deskripsi instruksi harus berupa teks',
      'url_image.string': 'URL gambar harus berupa teks',
    });

    final dataRecipe = req.input();
    dataRecipe['updated_at'] = DateTime.now().toIso8601String();

    // Cek apakah resep dengan ID tersebut ada
    final existingRecipe = await Recipes()
        .query()
        .where('id_resep', '=', idResep)
        .first();

    if (existingRecipe == null) {
      return Response.json({
        'message': 'Resep tidak ditemukan',
      }, 404);
    }

    // Update resep
    await Recipes()
        .query()
        .where('id_resep', '=', idResep)
        .update(dataRecipe);

    return Response.json(
      {
        "message": "Resep berhasil diperbarui",
        "data": dataRecipe,
      },
      200,
    );
  }

  // Menghapus resep berdasarkan ID (id_resep sebagai integer)
  Future<Response> destroy(int idResep) async {
    try {
      // Cari resep berdasarkan ID
      final recipe = await Recipes()
          .query()
          .where('id_resep', '=', idResep)
          .first();

      if (recipe == null) {
        return Response.json({
          'message': 'Resep tidak ditemukan',
        }, 404);
      }

      // Hapus resep
      await Recipes()
          .query()
          .where('id_resep', '=', idResep)
          .delete();

      return Response.json({
        'message': 'Resep berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus resep',
      }, 500);
    }
  }

  // Menampilkan semua resep
  Future<Response> index() async {
    final recipes = await Recipes()
        .query()
        .get();

    return Response.json({
      'message': 'Berhasil mendapatkan semua resep',
      'data': recipes,
    }, 200);
  }
}

final RecipeController recipeController = RecipeController();
