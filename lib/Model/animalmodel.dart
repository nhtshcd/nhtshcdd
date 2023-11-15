
class AnimalInfo {
  final String animal_name;
  final String animal_type;
  final String animalCount;
  final String fodderType;
  String animalHousingType;
  final String revenue;
  final String breed;
  final String estiManure;
  final String estimUrine;
  List<int> selctfodders;


  AnimalInfo(this.animal_name,this.animal_type, this.animalCount,
      this.fodderType, this.animalHousingType,
      this.revenue,this.breed,this.estiManure,this.estimUrine,
      this.selctfodders);

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'animal_name': animal_name,
      'animal_type': animal_type,
      'animal_count': animalCount,
      'fodderType': fodderType,
      'animalHouseType': animalHousingType,
      'revenue': revenue,
      'breed': breed,
      'estimanure': estiManure,
      'estiurine': estimUrine,
      'selectedfodders':selctfodders,
    };
  }

}