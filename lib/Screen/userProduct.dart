import 'package:devine/Screen/editScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';

class UserProducts extends StatelessWidget {
  static const String routeName = '/userProducts';
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final List<Product> _totalProducts =
        Provider.of<ProductData>(context).loadedProduct;
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Products',
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(EditScreen.routeName, arguments: {
            'title': 'New Product',
            'product': Product(
              description: '',
              imageUrl: '',
              id: '',
              title: '',
              price: 0,
            ),
          });
        },
      ),
      body: ListView.builder(
        itemCount: _totalProducts.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [
            ListTile(
              title: Text(
                _totalProducts[index].title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 18),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_totalProducts[index].imageUrl),
              ),
              trailing: Container(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditScreen.routeName, arguments: {
                          'title': 'Edit Product',
                          'product': _totalProducts[index],
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          await Provider.of<ProductData>(context, listen: false)
                              .removeProduct(_totalProducts[index].id);
                        } catch (e) {
                          _scaffold.currentState.showSnackBar(SnackBar(
                            content: Text(
                              'failed to delete !',
                              style: TextStyle(
                                  fontFamily: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .fontFamily),
                              textAlign: TextAlign.center,
                            ),
                          ));
                        }
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
