import 'package:flutter/material.dart';
import 'package:movie_feature/presentation/pages/home_movie_page.dart';

class SplashscreenPage extends StatefulWidget {
  static const String route = '/';

  const SplashscreenPage({Key? key}) : super(key: key);

  @override
  State<SplashscreenPage> createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  @override
  void initState() {
    super.initState();

    /// navigate to the dashboard
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeMoviePage.route,
          (route) => false,
        )
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: size.width * 0.4,
          height: size.width * 0.4,
          child: Image.asset(
            "assets/icon.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
