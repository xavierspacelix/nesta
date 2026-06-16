import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nesta/app/theme/app_theme.dart';
import 'package:nesta/core/providers/storage_provider.dart';

class AuthImage extends ConsumerStatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AuthImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  ConsumerState<AuthImage> createState() => _AuthImageState();
}

class _AuthImageState extends ConsumerState<AuthImage> {
  String? _signedUrl;
  bool _loading = true;
  bool _errored = false;

  @override
  void initState() {
    super.initState();
    _resolveUrl();
  }

  @override
  void didUpdateWidget(AuthImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _signedUrl = null;
      _loading = true;
      _errored = false;
      _resolveUrl();
    }
  }

  Future<void> _resolveUrl() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final signed = await storage.createSignedUrl(widget.imageUrl);
      if (mounted) {
        setState(() {
          _signedUrl = signed;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errored = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: AppTheme.neutral100,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_errored || _signedUrl == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: AppTheme.neutral100,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, color: AppTheme.neutral400),
        ),
      );
    }

    return Image.network(
      _signedUrl!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (_, __, ___) => Container(
        width: widget.width,
        height: widget.height,
        color: AppTheme.neutral100,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, color: AppTheme.neutral400),
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: widget.width,
          height: widget.height,
          color: AppTheme.neutral100,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
