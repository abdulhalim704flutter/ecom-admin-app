import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_admin/models/product_model.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/constanse.dart';
import 'package:ecom_admin/utils/widgets_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productDetails';
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late String id;
  late ProductModel productModel;
  late ProductProvider provider;
  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context)!.settings.arguments as String;
    provider = Provider.of<ProductProvider>(context);
    productModel = provider.getProductById(id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.name),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 250,
            fadeInDuration: const Duration(seconds: 2),
            fadeInCurve: Curves.easeInOut,
            imageUrl: productModel.imageUrl,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Center(
              child: const Icon(Icons.error),
            ),
          ),
          ListTile(
            title: Text(productModel.category.name),
            subtitle: Text(productModel.description ?? 'Description not found'),
          ),
          ListTile(
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDailog(
                    context: context,
                    title: 'Update price',
                    onSave: (value) {
                     provider.updateProductField(
                         id, 'price', num.parse(value));
                    });
              },
              icon: const Icon(Icons.edit),
            ),
            title: Text(
              '$currencySymboll${productModel.price}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            subtitle: Text(
              'After discount: $currencySymboll${provider.priceAfterDiscount(productModel.price, productModel.discount)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            trailing: IconButton(
              onPressed: () {
                showSingleTextInputDailog(
                    context: context,
                    title: 'Update Discount',
                    onSave: (value) {
                      provider.updateProductField(
                         id, 'discount', int.parse(value));
                    });
              },
              icon: const Icon(Icons.edit),
            ),
            title: Text(
              'Discount: ${productModel.discount}%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SwitchListTile(
              title: const Text('Featured'),
              value: productModel.featured,
              onChanged: (value) {
                provider.updateProductField(id, 'featured', value);
              }),
          SwitchListTile(
              title: const Text('Availabe'),
              value: productModel.available,
              onChanged: (value) {
                provider.updateProductField(id, 'available', value);
              })
        ],
      ),
    );
  }
}
