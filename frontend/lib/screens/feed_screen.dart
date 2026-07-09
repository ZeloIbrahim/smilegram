// pourToi (comme sur ig et tijtoj)

import "package:flutter/material.dart";
import "../models/photo_post.dart";
import "../services/api_service.dart";
import "../widgets/feed_item_card.dart";

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _api = ApiService();

  List<PhotoPost>? _photos;
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final photos = await _api.getFeed();
      setState(() {
        _photos = photos;
        _chargement = false;
      });
    } catch (e) {
      setState(() {
        _erreur = "Impossible de charger le fil.";
        _chargement = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pour toi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _chargement ? null : _charger,
            tooltip: "Actualiser",
          ),
        ],
      ),
      body: _chargement
          ? const Center(child: CircularProgressIndicator())
          : _erreur != null
              ? Center(child: Text(_erreur!))
              : RefreshIndicator(
                  onRefresh: _charger,
                  child: (_photos == null || _photos!.isEmpty)
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(40),
                              child: Text(
                                "Aucune photo pour le moment.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _photos!.length,
                          itemBuilder: (context, index) => FeedItemCard(
                        key: ValueKey(_photos![index].id),
                        photo: _photos![index],
                      ),
                        ),
                ),
    );
  }
}