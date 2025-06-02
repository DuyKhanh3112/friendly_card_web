import 'package:cloudinary/cloudinary.dart';
import 'package:friendly_card_web/config.dart';

class CloudinaryController {
  Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: Config.apiKey,
    apiSecret: Config.apiSecret,
    cloudName: Config.cloudName,
  );
  Future<String?> uploadImage(
      filePath, String fileName, String folderName) async {
    if (filePath != '') {
      final response = await cloudinary.upload(
        file: filePath,
        folder: folderName,
        fileName: fileName,
        progressCallback: (count, total) {},
      );
      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        return 'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723004576/app/logo_circle.png';
      }
    }
    return 'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723004576/app/logo_circle.png';
  }

  Future<void> deleteImage(String id, String folder) async {
    await cloudinary.destroy('$folder/$id');
  }
}
