// كلاس المنتج الواحد (زي اللي عندك)
class Responseproductsofbrands {
  int? producTID;
  String? producTNAME;
  String? description;
  double? price;
  int? brandID;
  String? brandName;
  int? caTID;
  String? caTNAME;
  int? stockLevel;
  String? productIMGUrl;

  Responseproductsofbrands({
    this.producTID,
    this.producTNAME,
    this.description,
    this.price,
    this.brandID,
    this.brandName,
    this.caTID,
    this.caTNAME,
    this.stockLevel,
    this.productIMGUrl,
  });

  Responseproductsofbrands.fromJson(Map<String, dynamic> json) {
    producTID = json['producT_ID'];
    producTNAME = json['producT_NAME'];
    description = json['description'];
    // لو السعر ممكن ييجي int أو double
    price = json['price'] is int ? (json['price'] as int).toDouble() : json['price'];
    brandID = json['brand_ID'];
    brandName = json['brand_Name'];
    caTID = json['caT_ID'];
    caTNAME = json['caT_NAME'];
    stockLevel = json['stockLevel'];
    productIMGUrl = json['productIMGUrl'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['producT_ID'] = producTID;
    data['producT_NAME'] = producTNAME;
    data['description'] = description;
    data['price'] = price;
    data['brand_ID'] = brandID;
    data['brand_Name'] = brandName;
    data['caT_ID'] = caTID;
    data['caT_NAME'] = caTNAME;
    data['stockLevel'] = stockLevel;
    data['productIMGUrl'] = productIMGUrl;
    return data;
  }
}


