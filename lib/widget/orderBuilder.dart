import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/model.dart';

class OrderBuilder extends StatefulWidget {
  final OrderItem orderItem;

  const OrderBuilder({Key key, this.orderItem}) : super(key: key);

  @override
  _OrderBuilderState createState() => _OrderBuilderState();
}

class _OrderBuilderState extends State<OrderBuilder> {
  bool _showSwitcher = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
          child: ListTile(
            trailing: IconButton(
              icon: Icon(
                _showSwitcher
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onPressed: () {
                setState(() {
                  _showSwitcher = !_showSwitcher;
                });
              },
            ),
            title: Text(
              'total : Ugx ${widget.orderItem.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontFamily: Theme.of(context).textTheme.bodyText2.fontFamily,
              ),
            ),
            subtitle: Text(
              'time :' +
                  DateFormat('dd - MM - yyyy hh:mm')
                      .format(widget.orderItem.date),
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText2.fontFamily,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: widget.orderItem.cart
                .map((element) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(element.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 17)),
                        Text(
                          '${element.quantity} x ${element.price}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ))
                .toList(),
          ),
          curve: Curves.bounceInOut,
          duration: Duration(seconds: 1),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: _showSwitcher ? 100 : 0,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
        )
      ],
    );
  }
}
