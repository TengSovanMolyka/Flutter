import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/app_state.dart';
import '../widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    AppState.instance.addListener(_refresh);
    AppState.instance.loadProducts();
  }

  @override
  void dispose() {
    AppState.instance.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE5E5),
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: AppState.instance.isLoadingProducts && productList.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : AppState.instance.productError != null && productList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(AppState.instance.productError!, textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => AppState.instance.loadProducts(forceRefresh: true),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : productList.isEmpty
                  ? const Center(child: Text('No products found.'))
                  : Padding(
                      padding: const EdgeInsets.all(15),
                      child: GridView.builder(
                        itemCount: productList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        itemBuilder: (context, index) => ProductCard(product: productList[index]),
                      ),
                    ),
    );
  }
}
