class TableModel {
  final int id;
  final String floor;
  final bool isReserved;

  TableModel({
    required this.id,
    required this.floor,
    required this.isReserved,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      floor: json['floor'],
      isReserved: json['isReserved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floor': floor,
      'isReserved': isReserved,
    };
  }
}
