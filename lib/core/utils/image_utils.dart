import 'package:flutter/foundation.dart' show kIsWeb;

class ImageUtils {
  static String getImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '';
    }

    if (kIsWeb) {
      return 'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}';
    }

    return imageUrl;
  }
}
