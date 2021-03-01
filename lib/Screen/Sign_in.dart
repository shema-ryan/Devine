import '../widget/widget.dart';
import 'package:flutter/material.dart';
import '../model/model.dart';
import 'package:provider/provider.dart';
import './screen.dart';

class SignIn extends StatefulWidget {
  static const String routeName = '/SignIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _hide = true;
  bool _loading = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<void> _signIn(
      {String email, String password, BuildContext context}) async {
    if (_formState.currentState.validate()) {
      _formState.currentState.save();
      setState(() {
        _loading = !_loading;
      });
      await Provider.of<Auth>(context, listen: false)
          .sigIn(email: email, password: password)
          .then((value) => Navigator.of(context)
              .pushNamedAndRemoveUntil(FirstScreen.routeName, (route) => false))
          .catchError((e) {
        setState(() {
          _loading = !_loading;
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
                message: 'Welcome back',
              ),
              Container(
                height: _size.height / 1.5,
                padding: EdgeInsets.all(_size.width * 0.05),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'email must contain @ ';
                        } else {
                          return null;
                        }
                      },
                      controller: _email,
                      decoration: InputDecoration(
                          hintText: 'email-address',
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    SizedBox(
                      height: _size.width * 0.05,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.length < 6) {
                                return 'password is short';
                              } else {
                                return null;
                              }
                            },
                            controller: _password,
                            key: ValueKey('HI'),
                            obscureText: _hide,
                            obscuringCharacter: '*',
                            decoration: InputDecoration(
                              hintText: 'password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _hide = !_hide;
                              });
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context)
                                  .pushNamed(ResetPassword.routeName);
                            },
                            child: Text(
                              'Forgot password ?',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      fontSize: _size.width * 0.035,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5)),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: _size.width * 0.1,
                    ),
                    _loading
                        ? Center(
                            child: const CircularProgressIndicator(),
                          )
                        : FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            height: _size.width * 0.127,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minWidth: double.infinity,
                            onPressed: () {
                              _signIn(
                                  email: _email.text,
                                  password: _password.text,
                                  context: context);
                            },
                            child: Text(
                              'Log in',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: _size.width * 0.05),
                            ),
                            color: Theme.of(context).primaryColor),
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          'Sign up',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: _size.width * 0.05),
                        ),
                        color: Colors.grey[50]),
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
