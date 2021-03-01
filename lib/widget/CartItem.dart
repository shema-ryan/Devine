import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';

class CartItem extends StatelessWidget {
  final String title;
  final int quantity;
  final double price;
  final String id;

  const CartItem({Key key, this.id, this.title, this.quantity, this.price})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double sum = quantity * price;
    return Dismissible(
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_outline_outlined,
          color: Colors.white,
          size: 25,
        ),
      ),
      key: ValueKey(Random().nextInt(200).toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(' Delete this item from cart ?',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18)),
                  title: Text(
                    'Confirm',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 18),
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline6
                                .fontFamily,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline6
                                .fontFamily,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ))
                  ],
                ));
      },
      onDismissed: (value) {
        Provider.of<Cart>(context, listen: false).removeItem(productId: id);
      },
      child: Card(
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                  child: Text(
                '\$$price',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              )),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline6.fontFamily),
          ),
          subtitle: Text('total : \$ ${sum.toStringAsFixed(2)}'),
          trailing: Text(
            '$quantity  x',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}
