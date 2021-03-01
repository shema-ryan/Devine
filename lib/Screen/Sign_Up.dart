import 'package:devine/Screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model.dart';
import '../widget/widget.dart';
import '../Screen/screen.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/sign_up';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _hide = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  bool _showLoading = false;
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
  }

  //helper functions
  //handling validating and signing up
  Future<void> signUp({email, password}) async {
    if (_formState.currentState.validate()) {
      setState(() {
        _showLoading = true;
      });
      _formState.currentState.save();
      await Provider.of<Auth>(context, listen: false)
          .signUp(
            email: email,
            password: password,
          )
          .then((_) => setState(() {
                _showLoading = !_showLoading;
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Account Created ',
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            'successfully !',
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    FirstScreen.routeName, (route) => false);
                              },
                              child: Text(
                                'ok',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 15,
                                    ),
                              ),
                            ),
                          ],
                        ));
              }))
          .catchError((e) {
        setState(() {
          _showLoading = !_showLoading;
        });
        _scaffold.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString() ?? 'shema is bad !',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
            ),
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffold,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                FirstScreen.routeName, (route) => false);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formState,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Clip(
                message: 'Create account',
              ),
              Container(
                height: _size.height / 1.5,
                padding: EdgeInsets.symmetric(horizontal: _size.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(
                      height: _size.width * 0.05,
                    ),
                    TextFormField(
                      controller: _email,
                      validator: (email) {
                        if (email.isEmpty || !email.contains('@')) {
                          return 'email must contain @ ';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'email-address',
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    SizedBox(
                      height: _size.width * 0.05,
                    ),
                    TextFormField(
                      validator: (password) {
                        if (password.isEmpty || password.length < 6) {
                          return 'password must be of more than 6 characters ';
                        } else {
                          return null;
                        }
                      },
                      obscuringCharacter: '*',
                      controller: _password,
                      key: ValueKey('HI'),
                      obscureText: _hide,
                      decoration: InputDecoration(
                        labelText: 'password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(
                      height: _size.width * 0.05,
                    ),
                    TextFormField(
                      controller: _confirm,
                      validator: (value) {
                        if (value != _password.text) {
                          return 'password doesn\'t match';
                        } else {
                          return null;
                        }
                      },
                      obscuringCharacter: '*',
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'confirm - password',
                          prefixIcon: Icon(Icons.person)),
                    ),
                    SizedBox(
                      height: _size.width * 0.127,
                    ),
                    !_showLoading
                        ? FlatButton(
                            height: _size.width * 0.127,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minWidth: double.infinity,
                            onPressed: () {
                              signUp(
                                password: _password.text,
                                email: _email.text,
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: _size.width * 0.05),
                            ),
                            color: Theme.of(context).primaryColor)
                        : CircularProgressIndicator(),
                    SizedBox(
                      height: _size.width * 0.025,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '    OR    ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _size.width * 0.025,
                    ),
                    FlatButton(
                        height: _size.width * 0.127,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(
                              width: 2,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.7)),
                        ),
                        minWidth: double.infinity,
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              FirstScreen.routeName, (route) => false);
                        },
                        child: Text(
                          'Log in',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: _size.width * 0.05),
                        ),
                        color: Colors.grey[50])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
