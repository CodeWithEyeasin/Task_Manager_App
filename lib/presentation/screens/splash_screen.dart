import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/presentation/screens/sign_in_screen.dart';
import 'package:task_manager_app/presentation/utils/assets_path.dart';
import 'package:task_manager_app/presentation/widgets/background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToSignIn();
  }

  Future<void> _moveToSignIn() async{
    await Future.delayed(const Duration(seconds: 2),);
    if(mounted){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 100,
            fit: BoxFit.scaleDown,
          ),
        ),
      )
    );
  }
}
