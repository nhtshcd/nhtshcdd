class EquipmentModel{
  final String equipName;
  final String equipCount;

  EquipmentModel(this.equipName, this.equipCount);

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'equipment_name': equipName,
      'equipment_count': equipCount,
    };
  }
}