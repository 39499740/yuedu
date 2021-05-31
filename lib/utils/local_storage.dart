import 'package:yuedu/utils/book_reptile.dart';

class LocalStorage {
  factory LocalStorage() => _getInstance();

  static LocalStorage get instance => _getInstance();

  static LocalStorage? _instance;

  LocalStorage._internal() {}

  static LocalStorage _getInstance() {
    if (_instance == null) {
      _instance = new LocalStorage._internal();
    }
    return _instance!;
  }
}
