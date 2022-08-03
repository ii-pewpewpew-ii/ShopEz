class product {
  final String productName;
  final String productPrice;
  final String productDescription;
  final String sellerName;

  product({
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.sellerName,
  });
  product.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot
  )
}
