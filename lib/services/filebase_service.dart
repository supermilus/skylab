import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FilebaseService {
  static const String accessToken = String.fromEnvironment('FILEBASE_IPFS_ACCESS_TOKEN');
  static const String endpoint = String.fromEnvironment('FILEBASE_IPFS_ENDPOINT');

  FilebaseService();

  Future<String?> uploadFile(File file, String fileName) async {
    final url = Uri.parse(endpoint);
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['name'] = fileName
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 201) {
      final respStr = await response.stream.bytesToString();
      final jsonResp = json.decode(respStr);
      return jsonResp['cid']; // IPFS CID
    } else {
      return null;
    }
  }

  /// TODO: Deletes all files for a user. This is a placeholder; implement actual logic if Filebase supports it.
  Future<bool> deleteAllUserFiles(String userId) async {
    // Filebase/IPFS does not natively support deleting by user, only by CID.
    // You must track uploaded CIDs per user and delete them individually if needed.
    // Implement this logic as your app tracks user uploads.
    return true;
  }
}
