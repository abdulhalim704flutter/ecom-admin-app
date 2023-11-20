import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_admin/pages/product_details_page.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/constanse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProductPage extends StatelessWidget {
  static final String routeName = '/viewproduct';
  const ViewProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Product'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => ListView.builder(
            itemCount: provider.productList.length,
            itemBuilder: (context, index) {
              final product = provider.productList[index];
              return InkWell(
                onTap: () => Navigator.pushNamed(
                    context, ProductDetailsPage.routeName,
                    arguments: product.id),
                child: Card(
                  color: Colors.lightBlueAccent.shade100,
                  child: ListTile(
                    leading: CachedNetworkImage(
                      fadeInDuration: const Duration(seconds: 2),
                      fadeInCurve: Curves.easeInOut,
                      imageUrl: product.imageUrl,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    subtitle: Text(
                      'Stock product: ${product.stock}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star),
                        Text(product.avgRating.toStringAsFixed(1),style: TextStyle(fontSize: 16),)
                      ],
                    )
                  ),
                ),
              );
            }),
      ),
    );
  }
}
