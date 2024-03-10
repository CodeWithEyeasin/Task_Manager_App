import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';

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
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _firstnameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lastnameTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 8,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Icon(Icons.arrow_circle_right_outlined),),),
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

