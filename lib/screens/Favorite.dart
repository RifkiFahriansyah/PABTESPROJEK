import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_bounty_hunter/data/candi_data.dart';
import 'package:projek_bounty_hunter/models/candi.dart';
import 'package:projek_bounty_hunter/screens/Detail.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late List<Candi> favorites;

  @override
  void initState() {
    super.initState();
    favorites = [];
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Candi> tempFavorites = [];

    for (Candi candi in candiList) {
      String key = 'favorite_${candi.name.replaceAll(' ', '_')}';
      bool isFavorite = prefs.getBool(key) ?? false;
      if (isFavorite) {
        tempFavorites.add(candi);
      }
    }

    setState(() {
      favorites = tempFavorites;
    });

    await prefs.setInt('favoriteCandiCount', tempFavorites.length);
  }

  Future<void> _toggleFavorite(Candi candi) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = 'favorite_${candi.name.replaceAll(' ', '_')}';
  bool currentStatus = prefs.getBool(key) ?? false;

  await prefs.setBool(key, !currentStatus);

  setState(() {
    candi.isFavorite = !currentStatus; // Update the UI state
  });

  // Refresh favorite list after updating
  _loadFavorites(); 
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(255, 248, 242, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: favorites.isEmpty
              ? const Center(child: Text('No favorites added yet'))
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final candi = favorites[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              candi: candi,
                              onFavoriteToggle: (updatedCandi) {
                                _toggleFavorite(updatedCandi);
                              },
                            ),
                          ),
                        );
                        _loadFavorites();
                      },
                      child: Card(
                        color: const Color.fromRGBO(252, 250, 237, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(4),
                        elevation: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Hero(
                                tag: candi.imageAsset,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: candi.imageAsset.startsWith('http')
                                      ? Image.network(
                                          candi.imageAsset,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                        )
                                      : Image.asset(
                                          candi.imageAsset,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 8,
                              ),
                              child: Text(
                                candi.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, bottom: 8),
                              child: Text(
                                candi.type,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
