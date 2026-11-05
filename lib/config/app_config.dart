class AppConfig {
  AppConfig._();

  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  static const Duration requestTimeout = Duration(seconds: 20);
  static const String fallbackImageAsset = 'assets/images/image_placeholder.png';
  static const String defaultAvatar = 'https://api.dicebear.com/7.x/initials/png?seed=E-Shop';
}
