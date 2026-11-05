import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/app_state.dart';
import '../utils/image_helper.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final appState = AppState.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFFFE9E9),

      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        foregroundColor: Colors.white,

        actions: [
          AnimatedBuilder(
            animation: appState,
            builder: (context, child) {
              final isFavorite = appState.isFavorite(product);

              return IconButton(
                onPressed: () {
                  final wasFavorite = appState.isFavorite(product);

                  appState.toggleFavorite(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        wasFavorite
                            ? "${product.name} removed from favorites"
                            : "${product.name} added to favorites",
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                  size: 28,
                ),
              );
            },
          ),

          const SizedBox(width: 5),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ================= PRODUCT IMAGE =================

            Column(
              children: [
                SizedBox(
                  height: 280,
                  child: PageView.builder(
                    itemCount: product.images.isEmpty ? 1 : product.images.length,
                    onPageChanged: (index) => setState(() => _currentImage = index),
                    itemBuilder: (context, index) => Center(
                      child: ProductImage(
                        source: product.images.isEmpty ? product.image : product.images[index],
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                if (product.images.length > 1) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(product.images.length, (index) => Container(
                      width: _currentImage == index ? 20 : 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _currentImage == index ? Colors.red : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 62,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: product.images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => setState(() => _currentImage = index),
                        child: Container(
                          width: 62,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: _currentImage == index ? Colors.red : Colors.black12),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: ProductImage(source: product.images[index], fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 20),

            // ================= PRODUCT NAME =================

            Text(
              product.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // ================= CATEGORY =================

            Text(
              product.category,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 15),

            // ================= PRICE =================

            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 20),

            // ================= DESCRIPTION =================

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // ================= ADD TO CART =================

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton.icon(
                onPressed: () {
                  appState.addToCart(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${product.name} added to cart",
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ),

                label: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}