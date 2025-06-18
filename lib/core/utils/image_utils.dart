class ImageUtils {
  static const String _baseImageUrl = 'https://image.tmdb.org/t/p';
  static const String _profileSize = 'w185';

  static String getProfileImageUrl(String? path) {
    if (path == null) return '';
    return '$_baseImageUrl/$_profileSize$path';
  }

  static String getBackdropImageUrl(String? path) {
    if (path == null) return '';
    return '$_baseImageUrl/w500$path';
  }

  static String getPosterImageUrl(String? path) {
    if (path == null) return '';
    return '$_baseImageUrl/w500$path';
  }
} 