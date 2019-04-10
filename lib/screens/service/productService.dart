
class ProductService {
  int id;
  String name;
  String stockStatus;
  String price;
  String priceHtml;
  List<Images> images;
  List htmlTags;

  ProductService(
      {this.id, this.name, this.stockStatus, this.price,this.images,this.priceHtml});
  
  factory ProductService.fromJson(Map<String, dynamic> json) {
  var list = json['images'] as List;
  List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();
 
    return ProductService(
        id: json['id'],
        name: json['name'],
        stockStatus: json['stock_status'],
        price: json['price'],
        images: imagesList
       );
  }
}

class Images {
  String src;
  Images({this.src});

  factory Images.fromJson(Map<String, dynamic> json) {
  
    return Images(src: json['src']);
  }
}
