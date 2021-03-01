import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../widget/widget.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = '/orderScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Your Order',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchAndSetOrder(),
          builder: (context, asyncSnapShot) {
            if (asyncSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (asyncSnapShot.hasData) {
              return Center(
                  child: Text(
                'No order placed yet',
                style: TextStyle(color: Colors.red),
              ));
            } else {
              return Consumer<Order>(
                  builder: (context, _orderData, child) => RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<Order>(context, listen: false)
                              .fetchAndSetOrder();
                        },
                        child: ListView.builder(
                            itemCount: _orderData.orderedItem.length,
                            itemBuilder: (BuildContext context, int index) =>
                                OrderBuilder(
                                  orderItem: _orderData.orderedItem[index],
                                )),
                      ));
            }
          },
        ));
  }
}
