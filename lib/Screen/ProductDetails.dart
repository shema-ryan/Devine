import 'package:flutter/material.dart';
import '../model/model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductDetails extends StatelessWidget {
  static const String routeName = '/Details';

  Widget build(BuildContext context) {
    final Product _product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              floating: true,
              expandedHeight: 500,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _product.title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 19),
                ),
                background: Hero(
                  tag: _product.id,
                  child: Image.network(
                    _product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothStarRating(
                          rating: 3,
                          allowHalfRating: true,
                          onRated: (value) {
                            print(value);
                          },
                          starCount: 5,
                        ),
                        Column(
                          children: [
                            Text(
                              '\$' + _product.price.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 20),
                            ),
                            Text(
                              '\\ per each',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Description : ',
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText1.fontFamily,
                          color: Colors.black87,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      _product.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 16),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 400,
                      child: Text(
                        'add To cart',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 20),
                      ),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    Container(
                      height: 1000,
                    )
                  ],
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
