import 'dart:io';
import 'package:ecom_admin/models/category_model.dart';
import 'package:ecom_admin/models/product_model.dart';
import 'package:ecom_admin/providers/product_provider.dart';
import 'package:ecom_admin/utils/widgets_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = '/newproduct';
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  String? localImagePath;
  CategoryModel? categoryModel;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Product'),
        actions: [
          IconButton(onPressed: _saveProduct, icon: const Icon(Icons.save))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: [
            _buildImageSection(),
            _buildCategorySection(),
            _buiTextFieldSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            localImagePath == null
                ? const Icon(
                    Icons.image,
                    size: 100,
                  )
                : Image.file(
                    File(localImagePath!),
                    width: 200,
                    height: 100,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                    onPressed: () {
                      _getImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text('Capture')),
                TextButton.icon(
                    onPressed: () {
                      _getImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.photo),
                    label: Text('Gallery'))
              ],
            ),
          ],
        ),
      ),
    );
    
  }

  void _getImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source,imageQuality: 80);
    if(file != null){
      setState(() {
        localImagePath = file.path;
      });
    }

  }

  Widget _buildCategorySection() {
    return Card(
      child: SingleChildScrollView(
        child: Consumer<ProductProvider>(
          builder:(context,provider, child) =>  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
            child: DropdownButtonFormField<CategoryModel>(
              value: categoryModel,
              hint: Text('Select a category'),
              isExpanded: true,
              items: provider.categoryList.map((category) => DropdownMenuItem<CategoryModel>(
                  value: category,
                  child: Text(category.name))).toList(),
              onChanged: (value){
                setState(() {
                  categoryModel = value;
                },);
              },
              validator: (value){
                if(value == null){
                  return 'this field must not be empty!';
                }return null;
              },
            ),
          ),
        ),
      ),
    );

  }

  _buiTextFieldSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Product Name',
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return 'this field must not be empty!';
              }return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Product Price',
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return 'this field must not be empty!';
              }return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Product Description(optional)',
            ),
            validator: (value){
             return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: _stockController,
            decoration: InputDecoration(
              filled: true,
              labelText: 'Product Stock',
            ),
            validator: (value){
              if(value == null || value.isEmpty){
                return 'this field must not be empty!';
              }return null;
            },
          ),
        ),
      ],
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _saveProduct() async{
    if(localImagePath == null){
      showMsg(context, 'Please select an image');
      return;
    }
    if(_formKey.currentState!.validate()){
      final imageUrl = await Provider.of<ProductProvider>(context,listen: false).uploadImage(localImagePath!);
      final productModel = ProductModel(
          name: _nameController.text,
          category: categoryModel!,
          price: int.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          imageUrl: imageUrl);
      EasyLoading.show(status: 'Please wait');
      await Provider.of<ProductProvider>(context,listen: false)
          .addProduct(productModel)
          .then((value){
            EasyLoading.dismiss();
        showMsg(context, 'Saved Product');
        _resetFields();
      })
          .catchError((error){
        EasyLoading.dismiss();
        showMsg(context, 'Could not product save');
      });
    }


  }

  void _resetFields() {
    setState(() {
      localImagePath = null;
      categoryModel = null;
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _stockController.clear();
    });
  }
}
