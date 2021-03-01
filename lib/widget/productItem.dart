import 'package:devine/Screen/ProductDetails.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product _product = Provider.of<Product>(context);
    final Cart _cart = Provider.of<Cart>(context, listen: false);
    final Auth _auth = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetails.routeName, arguments: _product);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 300,
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  _product.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 18),
                ),
                leading: IconButton(
                  icon: Icon(
                    !_product.isFavorite
                        ? Icons.favorite_border
                        : Icons.favorite,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _product.toggleFavorite(_auth.token);
                  },
                ),
                trailing: IconButton(
                  onPressed: () {
                    _cart.addCartItem(
                        cartItem: CartItem(
                          quantity: 1,
                          price: _product.price,
                          id: DateTime.now().microsecond.toString(),
                          title: _product.title,
                        ),
                        productId: _product.id);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'an item added !',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          _cart.undoAddItem(productId: _product.id);
                        },
                      ),
                    ));
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: Hero(
                tag: _product.id,
                child: Image.network(
                  _product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
