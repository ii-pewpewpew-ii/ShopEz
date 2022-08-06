import 'package:amazone_clone/cloud/cloud_service_products.dart';
import 'package:amazone_clone/cloud/constants.dart';
import 'package:amazone_clone/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cloud/product.dart';

class UpdateProductsFormView extends StatefulWidget {
  const UpdateProductsFormView({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateProductsFormView> createState() => _UpdateProductsFormViewState();
}

class _UpdateProductsFormViewState extends State<UpdateProductsFormView> {
  final cloud = CloudServices();
  String get sellerId => AuthService.firebase().currentUser!.id;
  final formKey = GlobalKey<FormState>();
  late String productName;
  late String productPrice;
  late String productDescription;
  late String sellerName;
  late String productImage;
  String? productCategory;

  @override
  Widget build(BuildContext context) {
    final updateProduct =
        ModalRoute.of(context)!.settings.arguments as UpdateProductArgument;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
          255,
          34,
          46,
          62,
        ),
        title: Center(
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.amazon,
                color: Colors.orange,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                'Update Your Product',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 15,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              buildProductNameField(
                  initial: updateProduct.updateProduct.productName),
              const SizedBox(height: 32),
              buildProductDescription(
                  initial: updateProduct.updateProduct.productDescription),
              const SizedBox(height: 32),
              buildCategories(),
              const SizedBox(height: 32),
              buildProductPrice(
                  initial: updateProduct.updateProduct.productPrice),
              const SizedBox(height: 32),
              buildProductImage(
                  initial: updateProduct.updateProduct.productImage),
              const SizedBox(height: 32),
              buildSellerName(initial: updateProduct.updateProduct.sellerName),
              const SizedBox(height: 32),
              buildSubmitButton(updateProduct)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductNameField({String? initial}) => TextFormField(
        initialValue: initial,
        decoration: const InputDecoration(
          labelText: 'Product Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 4) {
            return 'Name cannot be less than 4 characters';
          } else {
            return null;
          }
        },
        onChanged: ((value) => setState(() => productName = value)),
      );
  Widget buildProductDescription({String? initial}) => TextFormField(
        initialValue: initial,
        decoration: const InputDecoration(
          labelText: 'Product Description',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length > 150) {
            return 'Description cannot be more than 150 characters';
          } else if (value.isEmpty) {
            return 'Product must Contain a description';
          } else {
            return null;
          }
        },
        onChanged: ((value) => setState(() => productDescription = value)),
      );
  Widget buildProductPrice({String? initial}) => TextFormField(
        initialValue: initial,
        decoration: const InputDecoration(
          labelText: 'Product Price',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length > 150) {
            return 'Description cannot be more than 150 characters';
          } else {
            return null;
          }
        },
        onChanged: ((value) => setState(() => productPrice = value)),
      );
  Widget buildProductImage({String? initial}) => TextFormField(
        initialValue: initial,
        decoration: const InputDecoration(
          labelText: 'Image URL',
          border: OutlineInputBorder(),
        ),
        onChanged: ((value) => setState(() => productImage = value)),
      );
  Widget buildSellerName({String? initial}) => TextFormField(
        initialValue: initial,
        decoration: const InputDecoration(
          labelText: 'Seller Name',
          border: OutlineInputBorder(),
        ),
        onChanged: ((value) => setState(() => sellerName = value)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Seller Name cannot be empty';
          } else {
            return null;
          }
        },
      );
  Widget buildCategories({String? initial}) => DropdownButtonFormField<String>(
      validator: ((value) {
        if (value == null) {
          return 'Select a Category';
        } else {
          return null;
        }
      }),
      value: productCategory,
      items: categories.map(buildMenuItem).toList(),
      onChanged: ((value) => setState(() => productCategory = value)));

  Widget buildSubmitButton(UpdateProductArgument updateProduct) => TextButton(
      onPressed: () async {
        final isValid = formKey.currentState!.validate();
        if (isValid) {
          await cloud.updateProduct(
              documentId: updateProduct.updateProduct.productId,
              category: productCategory,
              productName: productName,
              productPrice: productPrice,
              productDescription: productDescription,
              sellerName: sellerName,
              productImage: productImage,
              sellerId: sellerId);
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
      child: const Text('Update Product'));

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      );
}

class UpdateProductArgument {
  final Product updateProduct;

  UpdateProductArgument(this.updateProduct);
}
