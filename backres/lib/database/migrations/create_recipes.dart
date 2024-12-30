import 'package:vania/vania.dart';

class CreateRecipes extends Migration {
  Future<void> up() async {
    super.up();
    await createTableNotExists('recipes', () {
      integer('id_resep', length: 11);
      primary('id_resep');
      string('title', length: 30); // Judul resep
      text('deskripsi_bahan'); // Deskripsi resep
      text('deskripsi_instruksi');
      string('maker', length: 50);
      // string('image');
      integer('id_category', length: 11);
      foreign('id_category', 'categories', 'id_category',
          constrained: true, onDelete: 'CASCADE');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('recipes');
  }
}
