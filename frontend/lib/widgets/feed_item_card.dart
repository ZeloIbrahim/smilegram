import "package:flutter/material.dart";
import "../models/photo_post.dart";
import "../services/api_service.dart";
import "comments_sheet.dart";

class FeedItemCard extends StatefulWidget {
  final PhotoPost photo;

  const FeedItemCard({super.key, required this.photo});

  @override
  State<FeedItemCard> createState() => _FeedItemCardState();
}

class _FeedItemCardState extends State<FeedItemCard> {
  final _api = ApiService();

  late bool _aLike;
  late int _likesCount;
  late int _commentsCount;

  @override
  void initState() {
    super.initState();
    _aLike = widget.photo.aLike;
    _likesCount = widget.photo.likesCount;
    _commentsCount = widget.photo.commentsCount;
  }


  @override
  void didUpdateWidget(covariant FeedItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photo.id != widget.photo.id) {
      _aLike = widget.photo.aLike;
      _likesCount = widget.photo.likesCount;
      _commentsCount = widget.photo.commentsCount;
    }
  }

  Future<void> _toggleLike() async {
    setState(() {
      _aLike = !_aLike;
      _likesCount += _aLike ? 1 : -1;
    });

    try {
      final resultat = await _api.toggleLike(widget.photo.id);
      setState(() {
        _aLike = resultat["a_like"] as bool;
        _likesCount = resultat["likes_count"] as int;
      });
    } catch (e) {
      setState(() {
        _aLike = !_aLike;
        _likesCount += _aLike ? 1 : -1;
      });
    }
  }

  void _ouvrirCommentaires() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentsSheet(
        photoId: widget.photo.id,
        onCommentsCountChanged: (nouveauCompte) {
          if (mounted) setState(() => _commentsCount = nouveauCompte);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photo;

    return Center(
      child: ConstrainedBox(

        constraints: const BoxConstraints(maxWidth: 470),
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: photo.photoProfil != null
                          ? NetworkImage("${ApiService.baseUrl}/uploads/${photo.photoProfil}")
                          : null,
                      child: photo.photoProfil == null ? const Icon(Icons.person, size: 18) : null,
                    ),
                    const SizedBox(width: 10),
                    Text(photo.username, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
          
              Image.network(
                "${ApiService.baseUrl}/uploads/${photo.photoPath}",
                width: double.infinity,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stack) => const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.broken_image_outlined, size: 32)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 12, 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _aLike ? Icons.favorite : Icons.favorite_border,
                        color: _aLike ? Colors.redAccent : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    Text("$_likesCount", style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: _ouvrirCommentaires,
                      icon: const Icon(Icons.chat_bubble_outline),
                    ),
                    Text("$_commentsCount", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}