import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_categories.dart';
import 'create_recipes.dart';
import 'create_favorites.dart';
import 'create_personal_access_tokens_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		await CreatePersonalAccessTokensTable().up();
    await CreateUserTable().up();
    await CreateCategories().up();
    await CreateRecipes().up();
    await CreateFavorites().up();
	}

  dropTables() async {
		await CreateFavorites().down();
    await CreatePersonalAccessTokensTable().down();
    await CreateRecipes().down();
    await CreateCategories().down();
    await CreateUserTable().down();
	 }
}
