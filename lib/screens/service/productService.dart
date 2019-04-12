
class ProductService {
  int id;
  String name;
  String stockStatus;
  String price;
  String priceHtml;
  String status;
  int totalSales;
  List<Images> images;

  ProductService(
      {this.id, this.name, this.stockStatus, this.price,this.images,this.priceHtml,this.totalSales,this.status});
  
  factory ProductService.fromJson(Map<String, dynamic> json) {
   
  var list = json['images'] as List;
  List<Images> imagesList = list.map((i) => Images.fromJson(i)).toList();
 
    return ProductService(
        id: json['id'],
        name: json['name'],
        stockStatus: json['stock_status'],
        price: json['price'],
        images: imagesList,
        totalSales: json['total_sales'],
        status: json['status']
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


class Attributes{
  String id;

}
