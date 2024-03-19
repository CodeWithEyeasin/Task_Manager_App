import 'package:flutter/material.dart';
import 'package:task_manager_app/presentation/controllers/auth_controller.dart';
import 'package:task_manager_app/presentation/data/models/login_response.dart';
import 'package:task_manager_app/presentation/data/models/response_object.dart';
import 'package:task_manager_app/presentation/data/services/network_caller.dart';
import 'package:task_manager_app/presentation/screens/auth/sign_up_screen.dart';
import 'package:task_manager_app/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_app/presentation/widgets/background_widget.dart';
import 'package:task_manager_app/presentation/widgets/snak_bar_message.dart';

import '../../data/utility/urls.dart';
import 'email_verification_screen.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100,),
                  Text('Get Started With',style: Theme.of(context).textTheme.titleLarge ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Password',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter Your Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                      child: Visibility(
                        visible: _isLoginInProgress==false,
                        replacement:const Center(
                          child: CircularProgressIndicator(),
                        ) ,
                        child: ElevatedButton(
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                _signIn();
                              }
                        },
                            child: const Icon(Icons.arrow_circle_right_outlined),),
                      ),),
                  const SizedBox(height: 60,),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailVerificationScreen(),
                          ),
                        );
                      },
                      child: const Text('Forgot Password'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?',style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),),
                      TextButton(onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          }, child: const Text('Sign up')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  Future<void> _signIn() async{
_isLoginInProgress=true;
setState(() {});
Map<String, dynamic> inputParams ={
  "email":_emailTEController.text.trim(),
  "password":_passwordTEController.text,
};
final ResponseObject response =
        await NetWorkCaller.postRequest(Urls.login, inputParams);
_isLoginInProgress=false;
setState(() {});
if(response.isSuccess){
  if(!mounted){
    return;
  }

LoginResponse loginResponse=LoginResponse.fromJson(response.responseBody);
  ///save the data to local cache
  await AuthController.saveUserData(loginResponse.userData!);
  await AuthController.saveUserToken(loginResponse.token!);

  if(mounted) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const MainBottomNavScreen()),
            (route) => false);
  }
}
else{
if(mounted){
  showSnackBarMessage(
      context, response.errorMessage ?? 'Login Failed! Try Again');
}
    }
  }


  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

