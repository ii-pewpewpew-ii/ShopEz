import 'package:amazone_clone/cloud/cloud_exceptions.dart';
import 'package:amazone_clone/cloud/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'package:uuid/uuid.dart';

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

  Future<bool> isSeller({required String? email}) async {
    final isseller = await users
        .where(sellerUserIdFieldName, isEqualTo: email)
        .get()
        .then(((value) => value.docs.isNotEmpty));
    return isseller;
  }

  Future<void> addSeller({required String email}) async {
    await users.add({sellerUserIdFieldName: email});
  }

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

  Future<void> addProductToCart(
      {required uId, required productId, required count}) async {
    final cart =
        FirebaseFirestore.instance.collection(cartCollectionName).doc(uId);
    final information = await cart.get();
    if (information.exists) {
      int flag = 0;
      late var products = information.get(productsFieldName);
      late var newProduct = [];
      for (dynamic product in products) {
        if (product[productIdFieldName] == productId) {
          newProduct.add({
            quantityFieldName: product[quantityFieldName] + count,
            productIdFieldName: productId
          });
          flag = 1;
        } else {
          newProduct.add(product);
        }
      }
      if (flag == 1) {
        await cart.update({productsFieldName: newProduct});
      }
      if (flag == 0) {
        products.add({productIdFieldName: productId, quantityFieldName: count});
        await cart.update({productsFieldName: products});
      }
    } else {
      var products = [
        {productIdFieldName: productId, quantityFieldName: count}
      ];
      cart.set({productsFieldName: products});
    }
  }

  Future<Product> getProductById({required String productId}) async {
    final product = await products.doc(productId).get();
    return Product(
      productId: product.id,
      category: product[productCategoryFieldName],
      productName: product[productNameFieldName],
      productPrice: product[productPriceFieldName],
      productDescription: product[productDescriptionFieldName],
      sellerName: product[sellerNameFieldName],
      productImage: product[productImageFieldName],
      sellerId: product[sellerIdFieldName],
    );
  }

  Future<void> fullfillOrder({required String orderId, required uId}) async {
    final sellerOrders = FirebaseFirestore.instance
        .collection(sellerDashCollectionName)
        .doc(uId);
    final information = await sellerOrders.get();
    final orders = information.get(ordersFieldName);
    late final orderToRemove;
    for (dynamic order in orders) {
      if (order[orderIdFieldName] == orderId) {
        orderToRemove = {
          customerEmailFieldName: order[customerEmailFieldName],
          orderIdFieldName: order[orderIdFieldName],
          productIdFieldName: order[productIdFieldName],
          quantityFieldName: order[quantityFieldName]
        };
        break;
      }
    }
    orders.removeWhere(
        (order) => order[orderIdFieldName] == orderToRemove[orderIdFieldName]);
    await sellerOrders.update({ordersFieldName: orders});
  }

  Future<void> removeProductFromCart({required productId, required uId}) async {
    final cart =
        FirebaseFirestore.instance.collection(cartCollectionName).doc(uId);
    final information = await cart.get();
    final cartItems = information.get(productsFieldName);
    late final productToRemove;
    for (dynamic items in cartItems) {
      if (items[productIdFieldName] == productId) {
        {
          productToRemove = {
            quantityFieldName: items[quantityFieldName],
            productIdFieldName: productId,
          };
        }
        break;
      }
    }
    cartItems.removeWhere((product) =>
        product[productIdFieldName] == productToRemove[productIdFieldName]);
    await cart.update({productsFieldName: cartItems});
  }

  Future<void> addOrderToSellerDash(
      {required sellerId,
      required productId,
      required count,
      required email}) async {
    final sellerOrders = FirebaseFirestore.instance
        .collection(sellerDashCollectionName)
        .doc(sellerId);
    final information = await sellerOrders.get();
    if (information.exists) {
      var orders = information.get(ordersFieldName);

      orders.add({
        orderIdFieldName: const Uuid().v1(),
        quantityFieldName: count,
        productIdFieldName: productId,
        customerEmailFieldName: email,
      });
      await sellerOrders.update({ordersFieldName: orders});
    } else {
      sellerOrders.set({
        ordersFieldName: [
          {
            orderIdFieldName: const Uuid().v1(),
            quantityFieldName: count,
            productIdFieldName: productId,
            customerEmailFieldName: email,
          }
        ]
      });
    }
  }

  Future<void> checkout({required String uId}) async {
    final cart =
        FirebaseFirestore.instance.collection(cartCollectionName).doc(uId);
    await cart.set({productsFieldName: []});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getOrders({required uId}) {
    final sellerOrders = FirebaseFirestore.instance
        .collection(sellerDashCollectionName)
        .doc(uId)
        .snapshots();
    return sellerOrders;
  }

  Stream<List<Product>> getCartItems({required Iterable<String> productIds}) {
    return products.snapshots().map((event) => event.docs
        .map((doc) => Product.fromSnapshot(doc))
        .where((element) => productIds.contains(element.productId))
        .toList());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getCartProductIds(
      {required uId}) {
    final cart = FirebaseFirestore.instance
        .collection(cartCollectionName)
        .doc(uId)
        .snapshots();
    return cart;
  }

  Stream<Iterable<Product>> getProductByCategory({required String category}) =>
      products.snapshots().map((event) => event.docs
          .map((doc) => Product.fromSnapshot(doc))
          .where((element) => element.category == category));

  Stream<Iterable<Product>> getProductBySellerId({required sellerId}) =>
      products.snapshots().map((event) => event.docs
          .map((doc) => Product.fromSnapshot(doc))
          .where((element) => element.sellerId == sellerId));
}
