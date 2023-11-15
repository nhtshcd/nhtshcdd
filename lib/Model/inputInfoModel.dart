class InputInformation {
  final String quantity;
  final String price;
  final String amount;


  InputInformation(this.quantity, this.price, this.amount);

  Map<String, dynamic> toMap() {
    return {
      'Quantity': quantity,
      'Price': price,
      'Amount': amount,
    };
  }
}