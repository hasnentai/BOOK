class CatAndProduct{
  int id;
  String name;
  List<Product> productlist;
  CatAndProduct({this.id,this.productlist,this.name});
  factory CatAndProduct.formJson(Map<String,dynamic> json){
    
    return CatAndProduct(
      id: json['id'],
      name: json['name'],
     
    );
  }
}

class Product{
  int id;
}