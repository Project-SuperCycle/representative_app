class DoshTypesManager {
  List<DoshItem> _typesList = [];

  List<DoshItem> get typesList => _typesList;

  void setTypesList(List<DoshItem> typesList) {
    _typesList = typesList;
  }
}

class DoshItem {
  final String id;
  final String name;
  final num price;

  DoshItem({required this.id, required this.name, required this.price});
}
