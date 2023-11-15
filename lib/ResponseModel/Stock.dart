

class Stock {
    String? batchNo;
    String? cCode;
    String? pCode;
    String? season;
    String? stock;

    Stock({this.batchNo, this.cCode, this.pCode, this.season, this.stock});

    factory Stock.fromJson(Map<String, dynamic> json) {
        return Stock(
            batchNo: json['batchNo'], 
            cCode: json['cCode'], 
            pCode: json['pCode'], 
            season: json['season'], 
            stock: json['stock'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['batchNo'] = this.batchNo;
        data['cCode'] = this.cCode;
        data['pCode'] = this.pCode;
        data['season'] = this.season;
        data['stock'] = this.stock;
        return data;
    }
}