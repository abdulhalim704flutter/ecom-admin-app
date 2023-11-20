import 'dart:io';
import 'package:ecom_admin/db/db_helper.dart';
import 'package:ecom_admin/models/product_model.dart';
import 'package:ecom_admin/utils/widgets_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../models/category_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  Future<void> addCategory(String name) async {
    final category = CategoryModel(name: name);
    return DbHelper.addCategory(category);
  }

  Future<void> addProduct(ProductModel productModel) async {
    return DbHelper.addProduct(productModel);
  }

  getAllCategorise() {
    DbHelper.getAllCategorise().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProduct() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
              (index) => ProductModel.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });

  }

  ProductModel getProductById(String id){
    return productList.firstWhere((element) => element.id == id);
  }
  num priceAfterDiscount(num price, int discount){
    return price - (price * discount ~/ 100);
  }

  Future<void> updateProductField(String id,String field,dynamic value){
    return DbHelper.updateProductField(id, {field: value});
  }

  Future<String> uploadImage(String path) async {
    final imageName = 'Image_${DateTime.now().millisecondsSinceEpoch}';
    final photoRef =
        FirebaseStorage.instance.ref().child('Pictures/$imageName');
    final uploadTask = photoRef.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
