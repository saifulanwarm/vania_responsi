import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      string('username', length: 25); // Nama pengguna (unik)
      string('email', length: 100); // Email (unik)
      string('password', length: 200);
      dateTime('created_at', nullable: true);
      dateTime('updated_at', nullable: true);
      dateTime('deleted_at', nullable: true);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
