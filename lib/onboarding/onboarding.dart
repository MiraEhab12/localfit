import 'package:flutter/material.dart';
import 'package:localfit/homescreen.dart';
import 'package:localfit/log_in/register.dart';

class OnBoarding extends StatefulWidget {
  static const String routename='onboarding';
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToHomeScreen() {
    Navigator.pushReplacementNamed(context, RegisterScreen.routename);
  }

  Widget _card(String title, String description, VoidCallback onPressed, {bool showBackButton = false}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff5C5545),
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 15),
            _buildPageIndicator(), // نقل المؤشر أسفل الصورة
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: showBackButton ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
              children: [
                if (showBackButton)
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: Color(0xff5C5646),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Color(0xff5C5646),
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: onPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dotIndicator(isActive: _currentPage == 0),
        SizedBox(width: 8),
        _dotIndicator(isActive: _currentPage == 1),
      ],
    );
  }

  Widget _dotIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff5C5646) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC8BBAA),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: _goToHomeScreen,
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 75),
                child: Column(
                  children: [
                    Image.asset("assets/images/onboarding1.png",
                    width: MediaQuery.of(context).size.width*1.17,
                      height: MediaQuery.of(context).size.height*0.46,
                    ),
                    Expanded(child: Container()),
                    _card(
                      'Welcome to LocalFit',
                      'Discover and support your favorite local brands. '
                          'LocalFit connects you with nearby stores making shopping local easier than ever!',
                          () => _pageController.nextPage(
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 75),
                child: Column(
                  children: [
                    Image.asset("assets/images/onboarding2.png",
                      width: MediaQuery.of(context).size.width*1.104,
                      height: MediaQuery.of(context).size.height*0.42,
                    ),
                    Expanded(child: Container()),
                    _card(
                      'Explore Local Shops',
                      'Find nearby stores and support small businesses. '
                          'Your purchases make a difference!',

                      _goToHomeScreen, // انتقال إلى الصفحة الرئيسية عند الضغط على السهم
                      showBackButton: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
