class Product {
  final int id;
  final String image;
  final List<String> images;
  final String name;
  final String category;
  final double price;
  final String description;
  bool favorite;

  Product({
    required this.id,
    required this.image,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    List<String>? images,
    this.favorite = false,
  }) : images = _uniqueImages(images ?? [image], image);

  static List<String> _uniqueImages(List<String> values, String primary) {
    final cleaned = values
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList();
    if (primary.trim().isNotEmpty && !cleaned.contains(primary.trim())) {
      cleaned.insert(0, primary.trim());
    }
    return cleaned;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final parsedImages = <String>[];
    if (rawImages is List) {
      for (final item in rawImages) {
        final value = item is String ? item : item?.toString() ?? '';
        final cleaned = value.trim().replaceAll('\\"', '').replaceAll('"', '');
        if (cleaned.startsWith('http://') || cleaned.startsWith('https://')) {
          parsedImages.add(cleaned);
        }
      }
    }

    final primaryImage = parsedImages.isNotEmpty
        ? parsedImages.first
        : (json['image']?.toString() ?? '');
    final rawCategory = json['category'];
    final categoryName = rawCategory is Map
        ? (rawCategory['name']?.toString() ?? 'Uncategorized')
        : (rawCategory?.toString() ?? 'Uncategorized');

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      image: primaryImage,
      images: parsedImages.isEmpty ? [primaryImage] : parsedImages,
      name: (json['title'] ?? json['name'] ?? 'Unnamed product').toString(),
      category: categoryName,
      price: (json['price'] as num?)?.toDouble() ??
          double.tryParse(json['price']?.toString() ?? '') ?? 0,
      description: (json['description'] ?? '').toString(),
    );
  }
}

// Kept as a shared list so existing screens and widgets can continue using it.
List<Product> productList = [];
