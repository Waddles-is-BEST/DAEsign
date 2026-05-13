import 'dart:io';
import 'package:http/http.dart' as http;

class R2Service {
  // Cloudflare R2 Configuration
  static const String bucketName = 'daesigntemp';
  static const String accountId = '0763786e67cbcd992136d82f35e7f81e';
  static const String bearerToken = 'cfut_ZIdyYlacbp9UbLGa1aend1Hdg6qlxDQgOlqYciNS8ad7578e';
  static const String r2Domain = 'https://daesigntemp.0763786e67cbcd992136d82f35e7f81e.r2.dev';

  /// Upload a file to Cloudflare R2
  /// Returns the public URL of the uploaded file
  static Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      // Read file bytes
      final fileBytes = await imageFile.readAsBytes();

      // Prepare request
      final objectKey = 'post_images/$fileName.jpg';
      final s3Url = 'https://$accountId.r2.cloudflarestorage.com/$bucketName/$objectKey';

      // Upload to R2 using S3 API
      final response = await http.put(
        Uri.parse(s3Url),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'image/jpeg',
        },
        body: fileBytes,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Return the public URL
        final publicUrl = '$r2Domain/$objectKey';
        print('Image uploaded successfully: $publicUrl');
        return publicUrl;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error uploading to R2: $e');
      return null;
    }
  }
}
