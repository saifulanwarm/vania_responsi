import 'package:vania/vania.dart';

class CreateFavorites extends Migration {
  Future<void> up() async{
  super.up();
  await createTableNotExists('favorites', () {
      integer('id', length: 11);
      primary('id');
      integer('id_resep', length: 11);
      foreign('id_resep', 'recipes', 'id_resep', constrained: true, onDelete: 'CASCADE');
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('favorites');
  }
}
