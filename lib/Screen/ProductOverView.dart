import 'package:flutter/material.dart';
import 'package:devine/Screen/screen.dart';
import '../widget/widget.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';

enum FilterOptions {
  showFavorite,
  showAll,
}

class ProductOverView extends StatefulWidget {
  @override
  _ProductOverViewState createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  bool _showFilter = false;
  bool _first = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    setState(() {
      _first = true;
    });
    await Provider.of<ProductData>(context, listen: false).fetchAndSetProduct();
    setState(() {
      _first = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context, listen: false);
    List<Product> loadedProduct = !_showFilter
        ? Provider.of<ProductData>(context, listen: false).loadedProduct
        : Provider.of<ProductData>(context, listen: false).filterProducts;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    _auth.email == 'mumberejofred@gmail.com' ? 'ADMIN' : '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 18),
                  ),
                  accountEmail: Text(
                    _auth.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductOverView()));
                  },
                  leading: Icon(
                    Icons.shop,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('Shop', style: TextStyle(fontSize: 18)),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(OrderScreen.routeName);
                  },
                  leading: Icon(
                    Icons.payment,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Orders',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                _auth.email == 'mumberejofred@gmail.com'
                    ? ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(UserProducts.routeName);
                        },
                        leading: Icon(
                          Icons.settings,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          'products',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Container(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(''),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton.icon(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _auth.logOut();
                      },
                      icon: Icon(
                        Icons.settings_backup_restore_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        'sign out',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 19),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.grey[50],
          actions: [
            Container(
              height: 60,
              width: 60,
              constraints: BoxConstraints(
                minHeight: 60,
                minWidth: 60,
              ),
              child: Consumer<Cart>(
                builder: (_, cartData, ch) {
                  return Stack(
                    children: [
                      ch,
                      cartData.cartItemCount != 0
                          ? Positioned(
                              top: 5,
                              right: 17,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.center,
                                height: 20,
                                width: 20,
                                child: FittedBox(
                                  child: Text(
                                    cartData.cartItemCount.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor),
                              ))
                          : Container()
                    ],
                  );
                },
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: Icon(
                    Icons.notifications_none_outlined,
                  ),
                ),
              ),
            ),
            PopupMenuButton(
                color: Theme.of(context).accentColor,
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (FilterOptions value) {
                  setState(() {
                    if (value == FilterOptions.showFavorite) {
                      _showFilter = true;
                    } else {
                      _showFilter = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text(
                          'showFavorites',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 18),
                        ),
                        value: FilterOptions.showFavorite,
                      ),
                      PopupMenuItem(
                        child: Text('showAll',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontSize: 18)),
                        value: FilterOptions.showAll,
                      )
                    ]),
          ],
          centerTitle: true,
          title: Text(
            'Categories',
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20),
          ),
          iconTheme: Theme.of(context).iconTheme),
      body: _first
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(5.0),
              itemCount: loadedProduct.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider<Product>.value(
                  value: loadedProduct[index],
                  child: ProductItem(),
                );
              }),
    );
  }
}
