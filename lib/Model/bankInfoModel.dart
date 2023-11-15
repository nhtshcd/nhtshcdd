
class BankInformation{
  final String acc_Type;
  final String acc_no;
  final String bank_name;
  final String branch_name;
  final String ifsc_code;

  BankInformation(this.acc_Type, this.acc_no, this.bank_name, this.branch_name, this.ifsc_code);

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'account_type': acc_Type,
      'account_no': acc_no,
      'bank_name': bank_name,
      'branch_name': branch_name,
      'ifsc_code': ifsc_code,
    };
  }
}