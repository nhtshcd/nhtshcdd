
class Catelog{
  final int IN_USE;
  final int DISP_SEQ;
  final int _ID;
  final String catalog_code;
  final String property_value;

  Catelog(this.IN_USE, this.DISP_SEQ, this._ID, this.catalog_code, this.property_value);

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'IN_USE': IN_USE,
      'DISP_SEQ': DISP_SEQ,
      '_ID': _ID,
      'catalog_code': catalog_code,
      'property_value': property_value,
    };
  }
}