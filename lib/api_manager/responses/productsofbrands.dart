class Responseproductsofbrands {
  int? producTID;
  String? producTNAME;
  String? description;
  double? price;
  int? brandID;
  String? brandName;
  String? brandLogoUrl; // ✅ تم إضافتها
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
    this.brandLogoUrl, // ✅ في الكونستركتور
    this.caTID,
    this.caTNAME,
    this.stockLevel,
    this.productIMGUrl,
  });

  Responseproductsofbrands.fromJson(Map<String, dynamic> json) {
    producTID = json['producT_ID'];
    producTNAME = json['producT_NAME'];
    description = json['description'];
    price =
    json['price'] is int ? (json['price'] as int).toDouble() : json['price'];
    brandID = json['brand_ID'];
    brandName = json['brand_Name'];
    brandLogoUrl = json['brand_LogoUrl']; // ✅ هنا كمان
    caTID = json['caT_ID'];
    caTNAME = json['caT_NAME'];
    stockLevel = json['stockLevel'];
    productIMGUrl = json['productIMGUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      'producT_ID': producTID,
      'producT_NAME': producTNAME,
      'description': description,
      'price': price,
      'brand_ID': brandID,
      'brand_Name': brandName,
      'caT_ID': caTID,
      'caT_NAME': caTNAME,
      'stockLevel': stockLevel,
      'productIMGUrl': productIMGUrl,
    };
  }
}
