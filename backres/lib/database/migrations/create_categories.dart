import 'package:vania/vania.dart';

class CreateCategories extends Migration {
  Future<void> up() async{
  super.up();
  await createTableNotExists('categories', () {
      integer('id_category', length: 11);
      primary('id_category');
      string('name', length: 50); 
      text('description'); // Deskripsi kategori (opsional)
      timeStamps(); 
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('categories');
  }
}
