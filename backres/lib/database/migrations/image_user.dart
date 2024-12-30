import 'package:vania/vania.dart';

class ImageUser extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('image_user', () {
      id();
      string('image');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('image_user');
  }
}
