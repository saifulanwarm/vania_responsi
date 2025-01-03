import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontres/widget/button_nav.dart';
import 'package:flutter_frontres/screen/settings.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  List<dynamic> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.136.11:8000/api/list-resep'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recipes = data['data'];
          isLoading = false;
        });
      } else {
        showError('Failed to load recipes: ${response.reasonPhrase}');
      }
    } catch (e) {
      showError('Error: $e');
    }
  }

  void showError(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gridRecipes = recipes.take(4).toList();
    final listRecipes = recipes.skip(4).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Daftar Resep', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : recipes.isEmpty
              ? Center(child: Text('Tidak ada resep tersedia.'))
              : PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Prescription History',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: gridRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = gridRecipes[index];
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: recipe['url_image'] != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: Image.network(
                                                recipe['url_image'],
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Icon(Icons.image_not_supported,
                                              size: 50),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        recipe['title'] ?? 'No Title',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recipe Recommendations',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.arrow_circle_right_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                        flex: 1,
                        child: ListView.builder(
                          itemCount: listRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = listRecipes[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: recipe['url_image'] != null
                                    ? Image.network(
                                        recipe['url_image'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.image_not_supported, size: 50),
                                title: Text(recipe['title'] ?? 'No Title'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Recipe by: ${recipe['maker'] ?? 'Unknown'}'),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.add_circle, color: Colors.blue, size: 30),
                                          onPressed: () {
                                            print('Add button pressed for ${recipe['title']}');
                                          },
                                        ),
                                        SizedBox(width: 8), // Jarak antara ikon dan teks
                                        Text(
                                          'Add Favorite',
                                          style: TextStyle(fontSize: 12, color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                onTap: () {
                                  // Tambahkan logika untuk membuka detail resep
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      ],
                    ),
                    Center(child: Text('Konten Kategori')),
                    const AboutPage(),
                  ],
                ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_recipe');
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
