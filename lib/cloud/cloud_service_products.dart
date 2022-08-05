import 'package:amazone_clone/cloud/cloud_exceptions.dart';
import 'package:amazone_clone/cloud/product.dart';
import 'package:amazone_clone/services/auth/auth_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class CloudServices {
  //Singleton Creation
  static final CloudServices _shared = CloudServices._sharedInstance();
  CloudServices._sharedInstance();
  factory CloudServices() => _shared;

  final users = FirebaseFirestore.instance.collection('sellers');
  final products = FirebaseFirestore.instance.collection('products');
  Future<String> createNewProduct(
      {required category,
      required productName,
      required productPrice,
      required productDescription,
      required sellerName,
      required productImage,
      required sellerId}) async {
    final document = await products.add({
      productNameFieldName: productName,
      productDescriptionFieldName: productDescription,
      productPriceFieldName: productPrice,
      productImageFieldName: productImage,
      productCategoryFieldName: category,
      sellerNameFieldName: sellerName,
      sellerIdFieldName: sellerId
    });
    return document.id;
  }

  Future<bool> isSeller({required String userId}) async {
    final isseller = await users
        .where(sellerUserIdFieldName, isEqualTo: userId)
        .get()
        .then(((value) => value.docs.isNotEmpty));
    return isseller;
  }

  Future<void> addSeller({required String userId}) async {
    await users.add({sellerUserIdFieldName: userId});
  }

  Stream<Iterable<Product>> getProductByCategory({required String category}) =>
      products.snapshots().map((event) => event.docs
          .map((doc) => Product.fromSnapshot(doc))
          .where((element) => element.category == category));

  Stream<Iterable<Product>> getProductBySellerId({required sellerId}) =>
      products.snapshots().map((event) => event.docs
          .map((doc) => Product.fromSnapshot(doc))
          .where((element) => element.sellerId == sellerId));

  Future<void> updateProduct(
      {required documentId,
      required category,
      required productName,
      required productPrice,
      required productDescription,
      required sellerName,
      required sellerId,
      required productImage}) async {
    try {
      await products.doc(documentId).update({
        productNameFieldName: productName,
        productDescriptionFieldName: productDescription,
        productPriceFieldName: productPrice,
        productImageFieldName: productImage,
        productCategoryFieldName: category,
        sellerNameFieldName: sellerName,
        sellerIdFieldName: sellerId
      });
    } catch (_) {
      throw CouldNotUpdateProduct();
    }
  }

  Future<void> deleteProduct({required documentId}) async {
    try {
      await products.doc(documentId).delete();
    } catch (e) {
      throw CouldNotRemoveProduct();
    }
  }
}
