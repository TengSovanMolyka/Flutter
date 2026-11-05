import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../models/app_state.dart';
import '../utils/image_helper.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final isFavorite = appState.isFavorite(product);

        return Container(
          width: 170,
          margin: const EdgeInsets.only(right: 15),

          child: Card(
            elevation: 5,
            shadowColor: Colors.black12,
            color: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            clipBehavior: Clip.antiAlias,

            child: InkWell(
              borderRadius: BorderRadius.circular(16),

              // =================================================
              // PRODUCT DETAIL
              // =================================================

              onTap: () {
                context.push(
                  '/product/${product.id}',
                  extra: product,
                );
              },

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // =================================================
                  // PRODUCT IMAGE + FAVORITE
                  // =================================================

                  Expanded(
                    flex: 6,

                    child: Stack(
                      children: [

                        // ================= IMAGE =================

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15),

                            child: ProductImage(
                              source: product.image,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),

                        // ================= FAVORITE =================

                        Positioned(
                          top: 10,
                          right: 10,

                          child: InkWell(
                            borderRadius:
                            BorderRadius.circular(30),

                            onTap: () {
                              final wasFavorite =
                              appState.isFavorite(product);

                              appState.toggleFavorite(product);

                              final message = wasFavorite
                                  ? "${product.name} removed from favorites"
                                  : "${product.name} added to favorites";

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  duration:
                                  const Duration(seconds: 1),
                                ),
                              );
                            },

                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,

                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,

                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // =================================================
                  // PRODUCT INFORMATION
                  // =================================================

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      8,
                      10,
                      8,
                    ),

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        // ================= NAME =================

                        Text(
                          product.name,

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        // ================= CATEGORY =================

                        Text(
                          product.category,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // =================================================
                        // PRICE + CART
                        // =================================================

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                          children: [

                            // ================= PRICE =================

                            Text(
                              "\$${product.price.toStringAsFixed(2)}",

                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),

                            // ================= CART =================

                            Container(
                              width: 38,
                              height: 38,

                              decoration: BoxDecoration(
                                color: Colors.red,

                                borderRadius:
                                BorderRadius.circular(8),
                              ),

                              child: IconButton(
                                padding: EdgeInsets.zero,

                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),

                                onPressed: () {
                                  appState.addToCart(product);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "${product.name} added to cart",
                                      ),
                                      duration:
                                      const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}