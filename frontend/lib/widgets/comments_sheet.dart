import "package:flutter/material.dart";
import "../models/comment.dart";
import "../services/api_service.dart";

class CommentsSheet extends StatefulWidget {
  final int photoId;
  final ValueChanged<int>? onCommentsCountChanged;

  const CommentsSheet({super.key, required this.photoId, this.onCommentsCountChanged});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _api = ApiService();
  final _texteCtrl = TextEditingController();

  List<Comment>? _comments;
  bool _chargement = true;
  bool _envoiEnCours = false;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  @override
  void dispose() {
    _texteCtrl.dispose();
    super.dispose();
  }

  Future<void> _charger() async {
    try {
      final comments = await _api.getComments(widget.photoId);
      setState(() {
        _comments = comments;
        _chargement = false;
      });
      widget.onCommentsCountChanged?.call(comments.length);
    } catch (e) {
      setState(() => _chargement = false);
    }
  }

  Future<void> _envoyerCommentaire() async {
    final texte = _texteCtrl.text.trim();
    if (texte.isEmpty) return;

    setState(() => _envoiEnCours = true);
    try {
      final nouveauCommentaire = await _api.postComment(widget.photoId, texte);
      setState(() {
        _comments = [...?_comments, nouveauCommentaire];
        _texteCtrl.clear();
      });
      widget.onCommentsCountChanged?.call(_comments!.length);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'envoi du commentaire")),
        );
      }
    } finally {
      if (mounted) setState(() => _envoiEnCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(child: _buildListe(scrollController)),
              const Divider(height: 1),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _texteCtrl,
                          decoration: const InputDecoration(hintText: "Ajouter un commentaire..."),
                          onSubmitted: (_) => _envoyerCommentaire(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _envoiEnCours ? null : _envoyerCommentaire,
                        icon: _envoiEnCours
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListe(ScrollController scrollController) {
    if (_chargement) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_comments == null || _comments!.isEmpty) {
      return Center(
        child: Text("Aucun commentaire pour le moment.", style: Theme.of(context).textTheme.bodyMedium),
      );
    }
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _comments!.length,
      itemBuilder: (context, index) {
        final c = _comments![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                child: Text(c.username.isNotEmpty ? c.username[0].toUpperCase() : "?", style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.username, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(c.texte, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}