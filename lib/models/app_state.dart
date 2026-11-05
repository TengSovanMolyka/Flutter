import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import 'product.dart';
import 'user.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal();

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  bool isLoadingProducts = false;
  String? productError;
  bool _productsLoaded = false;

  Future<void> loadProducts({bool forceRefresh = false}) async {
    if (isLoadingProducts || (_productsLoaded && !forceRefresh)) return;
    isLoadingProducts = true;
    productError = null;
    notifyListeners();
    try {
      final products = await ProductService.instance.fetchProducts();
      productList = products;
      _productsLoaded = true;
    } catch (error) {
      productError = error.toString();
    } finally {
      isLoadingProducts = false;
      notifyListeners();
    }
  }

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.instance.logout();
    _currentUser = null;
    notifyListeners();
  }

  final List<Product> _favorites = [];
  List<Product> get favorites => List.unmodifiable(_favorites);
  bool isFavorite(Product product) => _favorites.any((item) => item.id == product.id);

  void toggleFavorite(Product product) {
    final existingIndex = _favorites.indexWhere((item) => item.id == product.id);
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
      product.favorite = false;
    } else {
      _favorites.add(product);
      product.favorite = true;
    }
    notifyListeners();
  }

  final Map<int, Product> _cart = {};
  final Map<int, int> _quantities = {};
  Map<Product, int> get cart => Map.unmodifiable({
        for (final entry in _quantities.entries)
          if (_cart[entry.key] != null) _cart[entry.key]!: entry.value,
      });
  bool isInCart(Product product) => _quantities.containsKey(product.id);
  int getQuantity(Product product) => _quantities[product.id] ?? 0;

  void addToCart(Product product) {
    _cart[product.id] = product;
    _quantities[product.id] = (_quantities[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    if (!isInCart(product)) return;
    _quantities[product.id] = _quantities[product.id]! + 1;
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    final quantity = _quantities[product.id];
    if (quantity == null) return;
    if (quantity > 1) {
      _quantities[product.id] = quantity - 1;
    } else {
      removeFromCart(product);
      return;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _quantities.remove(product.id);
    _cart.remove(product.id);
    notifyListeners();
  }

  double get cartTotal {
    double total = 0;
    for (final entry in _quantities.entries) {
      final product = _cart[entry.key];
      if (product != null) total += product.price * entry.value;
    }
    return total;
  }

  void clearCart() {
    _cart.clear();
    _quantities.clear();
    notifyListeners();
  }
}
