import 'package:devine/Screen/screen.dart';
import 'package:devine/model/provider/Auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatefulWidget {
  static const routeName = '/firstScreen';
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getValue();
    });
  }

  Future<bool> getValue() async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    bool extracted = _sharedPreferences.getBool('starting') ?? false;
    return extracted;
  }

  Future<void> setValue({bool value}) async {
    final SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.setBool('starting', value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, _) => auth.authMode
          ? ProductOverView()
          : FutureBuilder(
              future: getValue(),
              initialData: false,
              builder: (context, async) {
                if (async.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 0.5,
                    )),
                  );
                } else if (async.hasData) {
                  return async.data == true
                      ? HomePage()
                      : SplashScreen(
                          change: (set) => setState(() {
                            setValue(value: set);
                          }),
                        );
                } else {
                  return Container(
                    color: Colors.yellow,
                  );
                }
              }),
    );
  }
}
