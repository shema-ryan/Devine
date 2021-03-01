import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../model/model.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = '/EditScreen';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final FocusNode _focusPrice = FocusNode();
  final FocusNode _focusDescription = FocusNode();
  final FocusNode _imageDescription = FocusNode();
  TextEditingController _controller = TextEditingController();
  var title = '';
  var _editedProduct =
      Product(price: 0, title: '', id: null, imageUrl: '', description: '');
  bool loaded = true;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _imageDescription.addListener(updateInterface);
  }

  @override
  void dispose() {
    super.dispose();
    _imageDescription.removeListener(updateInterface);
    _focusPrice.dispose();
    _focusDescription.dispose();
    _imageDescription.dispose();
    _controller.dispose();
  }

//helper functions
  void updateInterface() {
    if (!_imageDescription.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loaded) {
      Map<String, dynamic> _loadedProduct =
          ModalRoute.of(context).settings.arguments;
      title = _loadedProduct['title'];
      _editedProduct = _loadedProduct['product'];
      _controller.text = _editedProduct.imageUrl;
    }
    loaded = false;
  }

  void saveForm(Product product) {
    print('the product id : ${product.id}');
    setState(() {
      _isLoading = true;
    });
    if (_form.currentState.validate()) {
      _form.currentState.save();

      if (product.id != '') {
        Provider.of<ProductData>(context, listen: false)
            .updateProduct(product.id, product)
            .catchError((_) {
          return showDialog<Null>(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      'OOOps !',
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                          color: Theme.of(context).errorColor),
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      'Update Failed',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Okay',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: 18,
                                    ),
                          ))
                    ],
                  ));
        }).then((value) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        });
      } else {
        Provider.of<ProductData>(context, listen: false)
            .addProduct(product)
            .catchError((error) {
          return showDialog<Null>(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      'OOOps !',
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                          color: Theme.of(context).errorColor),
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      'Something Went Wrong',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Okay',
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontSize: 18,
                                    ),
                          ))
                    ],
                  ));
        }).then((value) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (_form.currentState.validate()) {
                _form.currentState.save();
                saveForm(_editedProduct);
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        elevation: 0,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _editedProduct.title,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          _editedProduct = Product(
                            price: _editedProduct.price,
                            title: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            description: _editedProduct.description,
                          );
                        },
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 18),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_focusPrice);
                        },
                        decoration: InputDecoration(labelText: 'title'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'title must contain more than 4 characters';
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        initialValue: _editedProduct.price.toString(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          _editedProduct = Product(
                            price: double.parse(value),
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            description: _editedProduct.description,
                          );
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_focusDescription);
                        },
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 18),
                        focusNode: _focusPrice,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'price',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'price must be of 2 figures';
                          } else if (double.tryParse(value) == null) {
                            return 'enter a valid number';
                          } else if (double.parse(value) <= 0) {
                            return 'price must be greater than 0 ';
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        initialValue: _editedProduct.description,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          _editedProduct = Product(
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            description: value,
                          );
                        },
                        focusNode: _focusDescription,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 18),
                        decoration: InputDecoration(
                          labelText: 'description',
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'description is empty';
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 200,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 3),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: _controller.text.isNotEmpty
                                ? Image.network(
                                    _controller.text,
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    child: Text(
                                      'add a url !',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 18),
                                    ),
                                  ),
                          ),
                          Expanded(
                              child: TextFormField(
                            controller: _controller,
                            focusNode: _imageDescription,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty || value.length < 10) {
                                return 'url must exceed 4 characters';
                              } else if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'enter a valid Url';
                              }
                              if (!value.endsWith('jpg') &&
                                  !value.endsWith('png') &&
                                  !value.endsWith('jpeg')) {
                                return 'enter a valid image URL';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                price: _editedProduct.price,
                                title: _editedProduct.title,
                                id: _editedProduct.id,
                                imageUrl: value,
                                description: _editedProduct.description,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 18),
                            onFieldSubmitted: (_) {
                              setState(() {});
                            },
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
