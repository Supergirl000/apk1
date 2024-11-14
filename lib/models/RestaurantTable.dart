class RestaurantTable {
  final String id;
  final String name;
  final int capacity;
  final bool isOccupied;

  RestaurantTable({
    required this.id,
    required this.name,
    required this.capacity,
    required this.isOccupied,
  });

  factory RestaurantTable.fromFirestore(Map<String, dynamic> data, String documentId) {
    return RestaurantTable(
      id: documentId,
      name: data['name'],
      capacity: data['capacity'],
      isOccupied: data['isOccupied'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'capacity': capacity,
      'isOccupied': isOccupied,
    };
  }
}