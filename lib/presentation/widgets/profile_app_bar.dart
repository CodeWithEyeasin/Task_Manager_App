import 'package:flutter/material.dart';
import 'package:task_manager_app/app.dart';
import 'package:task_manager_app/presentation/screens/auth/sign_in_screen.dart';

import '../utils/app_colors.dart';
//this is called top level function
PreferredSizeWidget get profileAppBar{
  return AppBar(
    backgroundColor: AppColors.themeColor,
    title:  Row(
      children: [
        const CircleAvatar(),
        const SizedBox(width: 12,),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rabbil Hasan',style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),),
              Text('rabbil@gmail.com',style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),)
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                TaskManager.navigatorKey.currentState!.context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    ),
  );
}