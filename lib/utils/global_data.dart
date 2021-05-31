class GlobalData {
  factory GlobalData() => _getInstance();

  static GlobalData get instance => _getInstance();

  static GlobalData? _instance;

  GlobalData._internal() {}

  static GlobalData _getInstance() {
    if (_instance == null) {
      _instance = new GlobalData._internal();
    }
    return _instance!;
  }

  double _textAreaWidth = 0;

  double get textAreaWidth => _textAreaWidth;
  double _textAreaHeight = 0;

  double get textAreaHeight => _textAreaHeight;

  void setTextAreaWH(double width, height) {
    _textAreaWidth = width;
    _textAreaHeight = height;
  }
}
