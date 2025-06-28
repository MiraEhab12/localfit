// class Responseproductsofbrands {
//   // ... حقول المنتج الحالية
//   final int? producTID;
//   final String? producTNAME;
//   final String? productIMGUrl;
//   final double? price;
//
//   // الحقول الجديدة التي يجب إضافتها
//   final String? brandName;
//   final String? brandLogoUrl;
//
//   Responseproductsofbrands({
//     this.producTID,
//     this.producTNAME,
//     this.productIMGUrl,
//     this.price,
//     this.brandName, // إضافة في الـ constructor
//     this.brandLogoUrl, // إضافة في الـ constructor
//   });
//
// // تأكد من تعديل factory constructor fromJson ليقرأ هذه الحقول من الـ JSON
// }

class Responseproductsofbrands {
  final int? producTID;
  final String? producTNAME;
  final String? description;
  final String? productIMGUrl;
  final double? price;
  final int? brandId;         // معرف البراند
  final String? brandName;    // اسم البراند
  final String? brandLogoUrl; // رابط لوجو البراند

  Responseproductsofbrands({
    this.producTID,
    this.producTNAME,
    this.description,
    this.productIMGUrl,
    this.price,
    this.brandId,
    this.brandName,
    this.brandLogoUrl,
  });

  factory Responseproductsofbrands.fromJson(Map<String, dynamic> json) {
    return Responseproductsofbrands(
      producTID: json['producT_ID'] as int?,
      producTNAME: json['producT_NAME'] as String?,
      description: json['description'] as String?,
      productIMGUrl: json['productIMGUrl'] as String?,
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : null,
      brandId: json['brand_ID'] as int?,
      brandName: json['brand_Name'] as String?,
      brandLogoUrl: json['brand_Logo'] as String?, // تأكد من اسم الحقل في JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producT_ID': producTID,
      'producT_NAME': producTNAME,
      'description': description,
      'productIMGUrl': productIMGUrl,
      'price': price,
      'brand_ID': brandId,
      'brand_Name': brandName,
      'brand_Logo': brandLogoUrl,
    };
  }
}

