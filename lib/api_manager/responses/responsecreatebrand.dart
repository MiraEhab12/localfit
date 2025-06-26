class Responseproductsofbrands {
  // ... حقول المنتج الحالية
  final int? producTID;
  final String? producTNAME;
  final String? productIMGUrl;
  final double? price;

  // الحقول الجديدة التي يجب إضافتها
  final String? brandName;
  final String? brandLogoUrl;

  Responseproductsofbrands({
    this.producTID,
    this.producTNAME,
    this.productIMGUrl,
    this.price,
    this.brandName, // إضافة في الـ constructor
    this.brandLogoUrl, // إضافة في الـ constructor
  });

// تأكد من تعديل factory constructor fromJson ليقرأ هذه الحقول من الـ JSON
}