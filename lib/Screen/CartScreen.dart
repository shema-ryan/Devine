import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart' show Cart, Order, OrderItem;
import '../widget/widget.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _spinner = false;
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Cart _cart = Provider.of<Cart>(context);
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        elevation: 0,
        title: Text(
          'Your Cart',
          style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total : ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    padding: const EdgeInsets.all(10.0),
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontSize: 18),
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text('\$${_cart.totalAmount.toStringAsFixed(2)}'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FlatButton(
                    child: !_spinner
                        ? Text(
                            'Order Now',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.8)),
                          )
                        : CircularProgressIndicator(),
                    onPressed: (_cart.totalAmount <= 0 || _spinner)
                        ? null
                        : () async {
                            setState(() {
                              _spinner = true;
                            });
                            await Provider.of<Order>(context, listen: false)
                                .addOrder(
                                    orderItem: OrderItem(
                              id: DateTime.now().toString(),
                              date: DateTime.now(),
                              total: _cart.totalAmount,
                              cart: [..._cart.cartData.values],
                            ))
                                .then((value) {
                              _cart.clearCart();
                              setState(() {
                                _spinner = false;
                              });
                            }).catchError((e) {
                              setState(() {
                                _spinner = false;
                              });
                              _scaffold.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  'pressing an order failed !',
                                  textAlign: TextAlign.center,
                                ),
                              ));
                            });
                          },
                  )
                ],
              ),
            ),
          ),
          if (_cart.totalAmount != 0)
            Column(
              children: [
                Text('|',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                Text('|',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                Text('|',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).primaryColor,
                )
                // RotatedBox(
                //     quarterTurns: 1,
                //     child: Text('>',
                //         style: TextStyle(
                //             color: Theme.of(context).primaryColor,
                //             fontSize: 20))),
              ],
            ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _cart.cartData.length,
              itemBuilder: (BuildContext context, int index) => CartItem(
                    id: _cart.cartData.keys.toList()[index],
                    price: _cart.cartData.values.toList()[index].price,
                    title: _cart.cartData.values.toList()[index].title,
                    quantity: _cart.cartData.values.toList()[index].quantity,
                  )),
        ],
      ),
    );
  }
}
