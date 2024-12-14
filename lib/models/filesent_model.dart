import 'dart:typed_data';

class Files {
  String name;
  String size;
  Uint8List image;

  Files({
    required this.name,
    required this.size,
    required this.image,
  });
}
