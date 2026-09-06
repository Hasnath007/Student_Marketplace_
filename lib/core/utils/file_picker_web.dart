// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

Future<Map<String, dynamic>?> pickImageFile() async {
  try {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();

    await uploadInput.onChange.first;
    final files = uploadInput.files;
    if (files == null || files.isEmpty) return null;

    final file = files[0];
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first;

    final bytes = Uint8List.fromList(reader.result as List<int>);
    final blobUrl = html.Url.createObjectUrl(file);

    return {
      'bytes': bytes,
      'name': file.name,
      'path': blobUrl,
    };
  } catch (e) {
    return null;
  }
}
