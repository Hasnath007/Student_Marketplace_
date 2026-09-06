import 'file_picker_stub.dart'
    if (dart.library.html) 'file_picker_web.dart' as picker_impl;

Future<Map<String, dynamic>?> pickImageFile() {
  return picker_impl.pickImageFile();
}
