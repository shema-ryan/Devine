import 'package:flutter/material.dart';
import '../model/Model/board.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/SplashScreen';
  final Function(bool value) change;
  SplashScreen({this.change});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _controller = PageController();
  int _page = 0;
  bool _pageController = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.width * 0.127,
            ),
            Text(
              'Devine',
              style: Theme.of(context).textTheme.headline6.copyWith(
                    fontSize: size.width * 0.07,
                  ),
            ),
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                itemCount: boardScreen.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.127,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          boardScreen[index].text,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                fontSize: size.width * 0.04,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.051,
                      ),
                      Image.asset(
                        boardScreen[index].image,
                        fit: BoxFit.cover,
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: size.width * 0.051,
            ),
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: boardScreen
                          .map((e) => Container(
                                margin: const EdgeInsets.all(2.0),
                                width: _page == boardScreen.indexOf(e).toInt()
                                    ? size.width * 0.051
                                    : size.width * 0.0254,
                                height: size.width * 0.0127,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.0),
                                  color: _page == boardScreen.indexOf(e)
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[500],
                                ),
                              ))
                          .toList(),
                    ),
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: double.infinity,
                      height: size.width * 0.102,
                      textColor: Theme.of(context).textTheme.bodyText2.color,
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      onPressed: () {
                        _pageController = true;
                        widget.change(_pageController);
                      },
                      child: Text(
                        'Continue',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: size.width * 0.046,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
