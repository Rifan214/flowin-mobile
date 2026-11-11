import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// Maximum allowed profile image size (5 MB) for in-memory preview & storage.
const int maxProfilePhotoBytes = 5 * 1024 * 1024;

const Set<String> _supportedPhotoExtensions = {
  'jpg',
  'jpeg',
  'png',
  'webp',
  'gif',
  'bmp',
};

/// Result of attempting to pick & validate a profile photo from the gallery.
sealed class PhotoPickResult {
  const PhotoPickResult();
}

final class PhotoPickSuccess extends PhotoPickResult {
  const PhotoPickSuccess(this.bytes, {this.fileName});

  final Uint8List bytes;
  final String? fileName;
}

final class PhotoPickCancelled extends PhotoPickResult {
  const PhotoPickCancelled();
}

final class PhotoPickFailure extends PhotoPickResult {
  const PhotoPickFailure(this.message);

  final String message;
}

/// Validates binary bytes and optional filename extension for profile photos.
String? validateProfilePhotoBytes(Uint8List bytes, {String? fileName}) {
  if (bytes.isEmpty) {
    return 'Selected file is empty. Please choose another image.';
  }
  if (bytes.lengthInBytes > maxProfilePhotoBytes) {
    return 'Image exceeds the 5 MB limit. Please select a smaller photo.';
  }
  if (fileName != null && fileName.contains('.')) {
    final ext = fileName.split('.').last.trim().toLowerCase();
    if (ext.isNotEmpty && !_supportedPhotoExtensions.contains(ext)) {
      return 'Unsupported file format (.$ext). Choose a JPG, PNG, or WebP image.';
    }
  }
  if (!_hasSupportedImageSignature(bytes)) {
    return 'Selected file is corrupted or not a supported image format.';
  }
  return null;
}

bool _hasSupportedImageSignature(Uint8List bytes) {
  // PNG: 89 50 4E 47 0D 0A 1A 0A
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47 &&
      bytes[4] == 0x0D &&
      bytes[5] == 0x0A &&
      bytes[6] == 0x1A &&
      bytes[7] == 0x0A) {
    return true;
  }
  // JPEG: FF D8 FF
  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return true;
  }
  // GIF: "GIF8"
  if (bytes.length >= 6 &&
      bytes[0] == 0x47 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x38) {
    return true;
  }
  // WebP: "RIFF....WEBP"
  if (bytes.length >= 12 &&
      bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46 &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50) {
    return true;
  }
  // BMP: "BM"
  if (bytes.length >= 2 && bytes[0] == 0x42 && bytes[1] == 0x4D) {
    return true;
  }
  return false;
}

/// Abstract gallery picker so production code works across Android & Web while
/// unit/widget tests can supply deterministic fakes.
abstract interface class ProfilePhotoPicker {
  Future<PhotoPickResult> pickFromGallery();
}

/// Default cross-platform gallery implementation backed by `image_picker`.
class ImagePickerProfilePhotoPicker implements ProfilePhotoPicker {
  ImagePickerProfilePhotoPicker({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<PhotoPickResult> pickFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (file == null) {
        return const PhotoPickCancelled();
      }
      final Uint8List bytes = await file.readAsBytes();
      final error = validateProfilePhotoBytes(bytes, fileName: file.name);
      if (error != null) {
        return PhotoPickFailure(error);
      }
      return PhotoPickSuccess(bytes, fileName: file.name);
    } on PlatformException catch (e) {
      debugPrint('ProfilePhotoPicker PlatformException(${e.code}): ${e.message}');
      if (e.code == 'photo_access_denied' || e.code == 'camera_access_denied') {
        return const PhotoPickFailure(
          'Photo gallery permission was denied. Enable photo access in device settings.',
        );
      }
      return PhotoPickFailure(
        'Could not open gallery (${e.message ?? e.code}). Please try again.',
      );
    } catch (e, stackTrace) {
      debugPrint('ProfilePhotoPicker error: $e\n$stackTrace');
      return const PhotoPickFailure(
        'Failed to read the selected photo. Please try another image.',
      );
    }
  }
}

