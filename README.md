# E SHOP - Flutter + Platzi Fake Store API

This project uses the Platzi Fake Store API (`https://api.escuelajs.co/api/v1`) for product data and demo authentication.

## Requirements

- Flutter SDK compatible with the Dart SDK constraint in `pubspec.yaml`
- Android Studio / VS Code with Flutter extension
- Internet connection

## Run the project

```bash
flutter pub get
flutter run
```

If you use a physical Android device, ensure it has internet access. Android's `INTERNET` permission is included in the manifest.

## Project additions

- `lib/config/app_config.dart`: API base URL and app constants.
- `lib/services/product_service.dart`: product list and product-by-ID requests.
- `lib/services/auth_service.dart`: login, registration, profile, and secure token storage.
- `lib/utils/image_helper.dart`: network/asset image widget with a local fallback.
- `assets/images/image_placeholder.png`: fallback for missing or broken product images.
- `postman/Platzi-Fake-Store.postman_collection.json`: importable Postman requests.

## API endpoints used

| Feature | Method | Endpoint |
|---|---|---|
| Product list | GET | `/products?offset=0&limit=50` |
| Product details | GET | `/products/{id}` |
| Categories | GET | `/categories` |
| Register | POST | `/users/` |
| Login | POST | `/auth/login` |
| Current profile | GET | `/auth/profile` |
| Refresh token | POST | `/auth/refresh-token` |

The API returns product `title`, `price`, `description`, `category`, and an `images` array. The app maps these fields to the existing `Product` model. Product detail uses a swipeable gallery when multiple image URLs are returned.

## Authentication note

The demo API issues access and refresh tokens. The app stores them using `flutter_secure_storage` and calls the profile endpoint with a Bearer access token. This is suitable for learning and API testing only; the public fake API is not a production identity provider. Never use real passwords or sensitive personal data with a demo API. Token refresh is documented and included in Postman, but automatic refresh/re-authentication is not enabled in this starter integration.

## Postman

Import the collection in `postman/`. Configure test credentials in Postman variables. The collection saves the returned tokens after a successful login.

## Notes

- Cart and favorites remain local app state and use product IDs so API products continue to work across screens.
- Product loading has loading, empty, error, and retry states.
- Broken or missing product images use `assets/images/image_placeholder.png`.
- The project was source-checked and the ZIP archive was verified, but this environment does not have the Flutter/Dart SDK installed. Run `flutter pub get` and `flutter analyze` locally before treating it as a fully compiled build.
