class JsonUtils {
  static M? fromJsonAsT<M>(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is List) {
      return _getListChildType<M>(json);
    } else {
      return _fromJsonSingle<M>(json as Map<String, dynamic>);
    }
  }

  static M? _fromJsonSingle<M>(Map<String, dynamic> json) {
    final String type = M.toString();
    return null;
  }

  static M? _getListChildType<M>(List<dynamic> data) {
    return null;
  }
}
