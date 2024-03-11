import 'package:flutter/material.dart';
import 'package:task_manager_app/presentation/data/services/network_caller.dart';
import 'package:task_manager_app/presentation/data/utility/urls.dart';
import 'package:task_manager_app/presentation/widgets/snak_bar_message.dart';

import '../../data/models/response_object.dart';
import '../../widgets/background_widget.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstnameTEController = TextEditingController();
  final TextEditingController _lastnameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey =GlobalKey<FormState>();

  bool _isRegistrationInProgress = false;

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
                  const SizedBox(height: 60,),
                  Text('Join With US',style: Theme.of(context).textTheme.titleLarge,),
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
                    controller: _firstnameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter Your First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lastnameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter Your Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter Your Mobile Number';
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
                      if(value!.length<=6){
                        return 'Password should more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _isRegistrationInProgress==false,
                      replacement:const Center(
                        child: CircularProgressIndicator(),
                      ) ,
                      child: ElevatedButton(
                        onPressed: ()  {
                          if(_formKey.currentState!.validate()){
                            _signUp();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),),
                    ),),
                  const SizedBox(height: 32,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Have account',style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),),
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text('Sign in')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ) ,
      ),
    );
  }

  Future<void> _signUp() async {
    _isRegistrationInProgress=true;
    setState(() {});
    Map<String, dynamic> inputParams={
      "email":_emailTEController.text.trim(),
      "firstName":_firstnameTEController.text.trim(),
      "lastName":_lastnameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      "password":_passwordTEController.text,
    };

    final ResponseObject response =
    await NetWorkCaller.postRequest(
        Urls.registration, inputParams);
    _isRegistrationInProgress=false;
    setState(() {});
    if(response.isSuccess){
      if(mounted){
        showSnackBarMessage(context, 'Registration Success! Please Login');
        Navigator.pop(context);
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, 'Registration Failed! Try Again',true);
      }
    }
  }


  @override
  void dispose() {
    _emailTEController.dispose();
    _firstnameTEController.dispose();
    _lastnameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

