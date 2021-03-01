import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './Screen/screen.dart';
import './model/model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (context, auth, prOrder) =>
              Order(auth.token, prOrder == null ? [] : prOrder.orderedItem),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductData>(
          update: (context, authData, previousProductData) => ProductData(
              authData.token,
              previousProductData == null
                  ? []
                  : previousProductData.loadedProduct),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'devine',
        theme: ThemeData(
          fontFamily: GoogleFonts.aBeeZee().fontFamily,
          cursorColor: Color(0xFFEF9B55),
          iconTheme: ThemeData.light().iconTheme.copyWith(
                color: Color(0xFFEF9B55).withOpacity(0.8),
              ),
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: GoogleFonts.aBeeZee(
                color: Color(0xFFEF9B55),
                fontWeight: FontWeight.bold,
              ),
              bodyText1: GoogleFonts.aBeeZee(
                color: Colors.black54,
              ),
              bodyText2: GoogleFonts.aBeeZee(
                color: Colors.white,
              )),
          accentColor: Color(0xFFEF9B55).withOpacity(0.7),
          primaryColor: Color(0xFFEF9B55),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FirstScreen(),
        routes: {
          EditScreen.routeName: (BuildContext context) => EditScreen(),
          UserProducts.routeName: (BuildContext context) => UserProducts(),
          OrderScreen.routeName: (BuildContext context) => OrderScreen(),
          CartScreen.routeName: (BuildContext context) => CartScreen(),
          ProductDetails.routeName: (BuildContext context) => ProductDetails(),
          ResetPassword.routeName: (BuildContext context) => ResetPassword(),
          FirstScreen.routeName: (BuildContext context) => FirstScreen(),
          SignUp.routeName: (BuildContext context) => SignUp(),
          SignIn.routeName: (BuildContext context) => SignIn(),
          HomePage.routeName: (BuildContext context) => HomePage(),
          SplashScreen.routeName: (BuildContext context) => SplashScreen(),
        },
      ),
    );
  }
}
