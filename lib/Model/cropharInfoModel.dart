class CropInformation{
  final String quantity;
  final String slctCrop;
  final String slctVty;
  final String slctGrade;

  CropInformation(this.quantity, this.slctCrop, this.slctVty, this.slctGrade);

  Map<String, dynamic> toMap() {
    return {
      'Quantity': quantity,
      'Crop': slctCrop,
      'Variety': slctVty,
      'Grade': slctGrade,
    };
  }
}