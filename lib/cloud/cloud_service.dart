import 'package:amazone_clone/cloud/cloud_exceptions.dart';
import 'package:amazone_clone/cloud/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class CloudServices {
  //Singleton Creation
  static final CloudServices _shared = CloudServices._sharedInstance();
  CloudServices._sharedInstance();
  factory CloudServices() => _shared;

  final products = FirebaseFirestore.instance.collection('products');
  Future<void> createNewProduct(
      {required category,
      required productName,
      required productPrice,
      required productDescription,
      required sellerName,
      required productImage}) async {
    await products.add({
      productNameFieldName: productName,
      productDescriptionFieldName: productDescription,
      productPriceFieldName: productPrice,
      productImageFieldName: productImage,
      productCategoryFieldName: category,
      sellerNameFieldName: sellerName
    });
  }

  Future<Iterable<Product>> getProductByCategory({required category}) async {
    try {
      return await products
          .where(productCategoryFieldName, isEqualTo: category)
          .get()
          .then((value) => value.docs.map((doc) {
                return Product.fromSnapshot(doc);
              }));
    } catch (e) {
      throw CouldNotRetrieveProductsByCategory();
    }
  }

  Future<Iterable<Product>> getProductBySeller({required sellerName}) async {
    try {
      return await products
          .where(sellerNameFieldName, isEqualTo: sellerName)
          .get()
          .then((value) => value.docs.map((doc) {
                return Product.fromSnapshot(doc);
              }));
    } catch (e) {
      throw CouldNotRetrieveProductsBySellerName();
    }
  }

  Future<void> updateProduct(
      {required documentId,
      required category,
      required productName,
      required productPrice,
      required productDescription,
      required sellerName,
      required productImage}) async {
    try {
      await products.doc(documentId).update({
        productNameFieldName: productName,
        productDescriptionFieldName: productDescription,
        productPriceFieldName: productPrice,
        productImageFieldName: productImage,
        productCategoryFieldName: category,
        sellerNameFieldName: sellerName
      });
    } catch (_) {
      throw CouldNotUpdateProduct();
    }
  }

  Future<void> deleteProduct({required documentId}) async {
    await products.doc(documentId).delete();
  }
}
