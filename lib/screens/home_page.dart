import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../models/category.dart';
import '../models/app_state.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AppState.instance.addListener(_refreshProducts);
    AppState.instance.loadProducts();
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_refreshProducts);
    super.dispose();
  }

  void _refreshProducts() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE5E5),

      appBar: AppBar(
        title: const Text(
          "E SHOP",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        ],

        backgroundColor: Colors.red,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // =================================================
            // BANNER
            // =================================================

            ClipRRect(
              borderRadius: BorderRadius.circular(15),

              child: Image.asset(
                "assets/images/banner.png",
                width: double.infinity,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey.shade300,

                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // CATEGORIES
            // =================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Categories",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                InkWell(
                  borderRadius: BorderRadius.circular(8),

                  onTap: () {
                    context.go('/products');
                  },

                  child: const Padding(
                    padding: EdgeInsets.all(5),

                    child: Text(
                      "See All",

                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 100,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,

                itemBuilder: (context, index) {
                  final category = categoryList[index];

                  return Container(
                    width: 75,

                    margin: const EdgeInsets.only(
                      right: 5,
                    ),

                    child: InkWell(
                      borderRadius:
                      BorderRadius.circular(15),

                      onTap: () {
                        // Later:
                        // Filter products by category
                        context.go('/products');
                      },

                      child: Column(
                        children: [

                          Container(
                            width: 65,
                            height: 65,

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                              BorderRadius.circular(15),

                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                ),
                              ],
                            ),

                            child: Icon(
                              category.icon,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            category.title,

                            style: const TextStyle(
                              fontSize: 12,
                            ),

                            textAlign: TextAlign.center,

                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // POPULAR PRODUCTS
            // =================================================

            _sectionHeader(
              "Popular Products",

                  () {
                context.go('/products');
              },
            ),

            const SizedBox(height: 15),

            if (AppState.instance.isLoadingProducts && productList.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.red),
              ))
            else if (AppState.instance.productError != null && productList.isEmpty)
              _productLoadError()
            else if (productList.isEmpty)
              const Center(child: Text('No products found.'))
            else
            SizedBox(
              height: 280,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,

                itemBuilder: (context, index) {
                  final product = productList[index];

                  return ProductCard(
                    product: product,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // NEW PRODUCTS
            // =================================================

            _sectionHeader(
              "New Products",

                  () {
                context.go('/products');
              },
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 280,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,

                itemBuilder: (context, index) {
                  final product = productList[index];

                  return ProductCard(
                    product: product,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _productLoadError() {
    return Center(
      child: Column(
        children: [
          Text(AppState.instance.productError ?? 'Unable to load products.'),
          TextButton(
            onPressed: () => AppState.instance.loadProducts(forceRefresh: true),
            child: const Text('Try again', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION HEADER
  // =========================================================

  Widget _sectionHeader(
      String title,
      VoidCallback onTap,
      ) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        InkWell(
          onTap: onTap,

          borderRadius:
          BorderRadius.circular(8),

          child: const Padding(
            padding: EdgeInsets.all(5),

            child: Text(
              "See All",

              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}