import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/Clip.dart';
import '../model/model.dart';
// import '../Screen/screen.dart';

class ResetPassword extends StatefulWidget {
  static const String routeName = '/resetPassword';
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  final TextEditingController _email = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
  }

  // reset Function
  Future<void> resetPassword({String email}) async {
    if (_formState.currentState.validate()) {
      _formState.currentState.save();
      await Provider.of<Auth>(context, listen: false)
          .resetPassword(
            email: email,
          )
          .then((_) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text(
                        'a password reset email was sent to ${_email.text}'),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Ok',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontSize: 15),
                          ))
                    ],
                  )).then((value) => Navigator.of(context).pop()))
          .catchError((e) {
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
            Navigator.of(context).pop();
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
                message: 'Forgot password ! \nDon\'t worry ',
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.all(20),
                          filled: true,
                          fillColor: Colors.grey[150],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey[300],
                                width: 0.1,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                              )),
                          labelText: 'email',
                          labelStyle: const TextStyle(fontSize: 20),
                          prefixIcon: Icon(Icons.email_outlined)),
                    ),
                    SizedBox(
                      height: _size.width * 0.127,
                    ),
                    FlatButton(
                        height: _size.width * 0.127,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minWidth: double.infinity,
                        onPressed: () {
                          if (_formState.currentState.validate()) {
                            resetPassword(email: _email.text);
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          'Reset',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: _size.width * 0.05),
                        ),
                        color: Theme.of(context).primaryColor),
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
