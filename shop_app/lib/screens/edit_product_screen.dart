import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusnode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editingProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusnode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusnode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusnode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as dynamic;

      if (productId != null) {
        _editingProduct =
            Provider.of<Products>(context, listen: false).findbyid(productId);
        _initValues = {
          'title': _editingProduct.title,
          'description': _editingProduct.description,
          'price': _editingProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editingProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusnode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editingProduct.id.isNotEmpty) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editingProduct.id, _editingProduct);
    } else {
      Provider.of<Products>(context, listen: false).addproduct(_editingProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save_rounded))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the Tilte';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editingProduct = Product(
                      id: _editingProduct.id,
                      title: newValue.toString(),
                      description: _editingProduct.description,
                      price: _editingProduct.price,
                      imageUrl: _editingProduct.imageUrl,
                      isFavorite: _editingProduct.isFavorite);
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the Price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'please provide a Valid Number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'provide a number greater than zero';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editingProduct = Product(
                      id: _editingProduct.id,
                      title: _editingProduct.title,
                      description: _editingProduct.description,
                      price: double.parse(newValue.toString()),
                      imageUrl: _editingProduct.imageUrl,
                      isFavorite: _editingProduct.isFavorite);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the description';
                  }
                  if (value.length < 10) {
                    return 'should be at least 10 character long';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _editingProduct = Product(
                      id: _editingProduct.id,
                      title: _editingProduct.title,
                      description: newValue.toString(),
                      price: _editingProduct.price,
                      imageUrl: _editingProduct.imageUrl,
                      isFavorite: _editingProduct.isFavorite);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Center(child: Text('Enter a URL'))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusnode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Provide a Image url';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Enter a valid URL';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editingProduct = Product(
                            id: _editingProduct.id,
                            title: _editingProduct.title,
                            description: _editingProduct.description,
                            price: _editingProduct.price,
                            imageUrl: newValue.toString(),
                            isFavorite: _editingProduct.isFavorite);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
