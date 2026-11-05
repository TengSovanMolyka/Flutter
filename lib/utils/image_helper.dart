import 'package:flutter/material.dart';
import '../config/app_config.dart';

class ProductImage extends StatelessWidget {
  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ProductImage({
    super.key,
    required this.source,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  bool get _isNetworkImage =>
      source.startsWith('https://') || source.startsWith('http://');

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      AppConfig.fallbackImageAsset,
      fit: fit,
      width: width,
      height: height,
    );
    if (source.trim().isEmpty) return fallback;
    if (_isNetworkImage) {
      return Image.network(
        source,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : SizedBox(
                width: width,
                height: height,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
      );
    }
    return Image.asset(
      source,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
