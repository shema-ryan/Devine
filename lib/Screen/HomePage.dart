import 'package:devine/Screen/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/HomePage';
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/BoardImages/arrived.png'),
        )),
        child: DecoratedBox(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(_size.width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Devine Fashion',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: _size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: _size.width * 0.013,
                  ),
                  Text(
                    'Our service are elite and highly rated.....\ndelivery with in 30 minutes around kampala',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  SizedBox(
                    height: _size.width * 0.8,
                  ),
                  FlatButton(
                    height: _size.width * 0.127,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        width: 0.5,
                      ),
                    ),
                    minWidth: double.infinity,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        SignIn.routeName,
                      );
                    },
                    child: Text(
                      'Log in',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: _size.width * 0.05),
                    ),
                    color: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .color
                        .withOpacity(0.9),
                  ),
                  SizedBox(
                    height: _size.width * 0.025,
                  ),
                  FlatButton(
                    height: _size.width * 0.127,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .color
                            .withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    minWidth: double.infinity,
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUp.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: _size.width * 0.05),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9)),
        ),
      ),
    );
  }
}
