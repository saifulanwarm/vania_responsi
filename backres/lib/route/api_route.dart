import 'package:backres/app/http/controllers/auth_controller.dart';
import 'package:backres/app/http/controllers/user_controller.dart';
import 'package:backres/app/http/controllers/recipe_controller.dart';
import 'package:backres/app/http/controllers/category_controller.dart';
import 'package:backres/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix('api');

    // Kategori
    Router.post('/add-category', categoryController.create);
    Router.get('/daftar-category/{id_category}', categoryController.show);
    Router.get('/list-category', categoryController.index);
    Router.put('/edit-category/{id_category}', categoryController.update);
    Router.delete('/hapus-category/{id_category}', categoryController.destroy);

    // Resep
    Router.post('/add-recipe', recipeController.create);
    Router.get('/daftar-recipe/{id_resep}', recipeController.show);
    Router.get('/list-recipe', recipeController.index);
    Router.put('/edit-recipe/{id_resep}', recipeController.update);
    Router.delete('/hapus-recipe/{id_resep}', recipeController.destroy);

    // Route untuk registrasi dan login
    Router.group(() {
      Router.post('register', authController.register); // Registrasi
      Router.post('login', authController.login); // Login
    }, prefix: 'auth');

    // Menggunakan middleware untuk route yang membutuhkan autentikasi
    Router.get('me', authController.me).middleware([AuthenticateMiddleware()]);

    // Route untuk user yang memerlukan autentikasi
    Router.group(() {
      Router.patch('update-password', authController.updatePassword);
      Router.get('', userController.create);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);

    // Route untuk recipe
    Router.group(() {
      Router.post(
          'create', recipeController.create); // Endpoint untuk membuat resep
    }, prefix: 'recipe', middleware: [AuthenticateMiddleware()]);
  }
}
