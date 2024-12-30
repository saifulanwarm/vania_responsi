import 'package:vania/vania.dart';
import 'package:backres/app/models/categories.dart';

class CategoryController extends Controller {
  // Menambahkan kategori baru dengan id_category manual
  Future<Response> create(Request req) async {
    req.validate({
      'id_category': 'required|integer',
      'name': 'required|string',
      'description': 'required|string',
    }, {
      'id_category.required': 'ID kategori tidak boleh kosong',
      'id_category.integer': 'ID kategori harus berupa angka',
      'name.required': 'Nama kategori tidak boleh kosong',
      'name.string': 'Nama kategori harus berupa teks',
      'description.required': 'Deskripsi kategori tidak boleh kosong',
      'description.string': 'Deskripsi kategori harus berupa teks',
    });

    final dataCategory = req.input();
    dataCategory['created_at'] = DateTime.now().toIso8601String();
    dataCategory['updated_at'] = DateTime.now().toIso8601String();

    // Cek apakah ID kategori sudah ada
    final existingCategory = await Categories()
        .query()
        .where('id_category', '=', dataCategory['id_category'])
        .first();

    if (existingCategory != null) {
      return Response.json({
        "message": "Kategori dengan ID ini sudah ada",
      }, 409);
    }

    // Cek apakah nama kategori sudah ada
    final existingCategoryByName = await Categories()
        .query()
        .where('name', '=', dataCategory['name'])
        .first();

    if (existingCategoryByName != null) {
      return Response.json({
        "message": "Nama kategori sudah ada",
      }, 409);
    }

    // Simpan kategori baru
    await Categories().query().insert(dataCategory);

    return Response.json(
      {
        "message": "Kategori berhasil ditambahkan",
        "data": dataCategory,
      },
      201,
    );
  }

  // Menampilkan kategori berdasarkan ID
  Future<Response> show(int idCategory) async {
    final category = await Categories()
        .query()
        .where('id_category', '=', idCategory)
        .first();

    if (category == null) {
      return Response.json({
        'message': 'Kategori tidak ditemukan',
      }, 404);
    }

    return Response.json({
      'message': 'Berhasil mendapatkan kategori',
      'data': category,
    }, 200);
  }

  // Mengupdate kategori berdasarkan ID
  Future<Response> update(Request req, int idCategory) async {
    req.validate({
      'name': 'required|string',
      'description': 'required|string',
    }, {
      'name.required': 'Nama kategori tidak boleh kosong',
      'name.string': 'Nama kategori harus berupa teks',
      'description.required': 'Deskripsi kategori tidak boleh kosong',
      'description.string': 'Deskripsi kategori harus berupa teks',
    });

    final dataCategory = req.input();
    dataCategory['updated_at'] = DateTime.now().toIso8601String();

    final existingCategory = await Categories()
        .query()
        .where('id_category', '=', idCategory)
        .first();

    if (existingCategory == null) {
      return Response.json({
        'message': 'Kategori tidak ditemukan',
      }, 404);
    }

    await Categories()
        .query()
        .where('id_category', '=', idCategory)
        .update(dataCategory);

    return Response.json({
      "message": "Kategori berhasil diperbarui",
      "data": dataCategory,
    }, 200);
  }

  // Menghapus kategori berdasarkan ID
  Future<Response> destroy(int idCategory) async {
    final category = await Categories()
        .query()
        .where('id_category', '=', idCategory)
        .first();

    if (category == null) {
      return Response.json({
        'message': 'Kategori tidak ditemukan',
      }, 404);
    }

    await Categories()
        .query()
        .where('id_category', '=', idCategory)
        .delete();

    return Response.json({
      'message': 'Kategori berhasil dihapus',
    }, 200);
  }

  // Menampilkan semua kategori dengan pagination
  Future<Response> index(Request req) async {
    final page = int.tryParse(req.input('page') ?? '1') ?? 1;
    final perPage = 10; // Batas data per halaman
    final offset = (page - 1) * perPage;

    final categories = await Categories()
        .query()
        .limit(perPage)
        .offset(offset)
        .get();

    final totalCategories = await Categories().query().count();

    return Response.json({
      'message': 'Berhasil mendapatkan semua kategori',
      'data': categories,
      'pagination': {
        'current_page': page,
        'per_page': perPage,
        'total': totalCategories,
      },
    }, 200);
  }
}

final CategoryController categoryController = CategoryController();
