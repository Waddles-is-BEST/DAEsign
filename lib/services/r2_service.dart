import 'dart:io';
import 'package:http/http.dart' as http;

class R2Service {
  // Cloudflare R2 Configuration
  static const String bucketName = 'daesigntemp';
  static const String accountId = '0763786e67cbcd992136d82f35e7f81e';
  static const String bearerToken = 'cfut_ZIdyYlacbp9UbLGa1aend1Hdg6qlxDQgOlqYciNS8ad7578e';
  static const String r2Domain = 'https://pub-0b054e4b7b904f29a4aa3cc0989a9175.r2.dev';

  /// Upload a file to Cloudflare R2 using the Cloudflare API
  /// Returns the public URL of the uploaded file
  static Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      // Read file bytes
      final fileBytes = await imageFile.readAsBytes();

      // Prepare object key
      final objectKey = 'post_images/$fileName.jpg';

      // Use Cloudflare API endpoint for direct upload
      final uploadUrl = Uri.parse(
        'https://api.cloudflare.com/client/v4/accounts/$accountId/r2/buckets/$bucketName/objects/$objectKey',
      );

      print('Uploading to R2: $objectKey');
      print('Upload URL: $uploadUrl');

      // Upload to R2 using Cloudflare API
      final response = await http.put(
        uploadUrl,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'image/jpeg',
        },
        body: fileBytes,
      ).timeout(const Duration(seconds: 30));

      print('Upload response status: ${response.statusCode}');
      print('Upload response body: ${response.body}');

      if (response.statusCode == 200) {
        // Return the public URL (bucket name is already configured in the subdomain)
        final publicUrl = '$r2Domain/$objectKey';
        print('✅ Image uploaded successfully to R2!');
        print('   Object Key: $objectKey');
        print('   Public URL: $publicUrl');
        print('   R2 Domain: $r2Domain');
        print('   Bucket: $bucketName');
        return publicUrl;
      } else {
        throw Exception(
          'Failed to upload image. Status: ${response.statusCode}. Response: ${response.body}',
        );
      }
    } catch (e) {
      print('Error uploading to R2: $e');
      return null;
    }
  }
}
