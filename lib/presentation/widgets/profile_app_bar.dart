import 'package:flutter/material.dart';
import 'package:task_manager_app/app.dart';
import 'package:task_manager_app/presentation/controllers/auth_controller.dart';
import 'package:task_manager_app/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_app/presentation/screens/update_profile_screen.dart';

import '../utils/app_colors.dart';
//this is called top level function
PreferredSizeWidget get profileAppBar{
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.themeColor,
    title:  GestureDetector(
      onTap: (){
        Navigator.push(
          TaskManager.navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => const UpdateProfileScreen(),
          ),
        );
      },
      child: Row(
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
            onPressed: ()async {
              await AuthController.clearUserData();

              Navigator.pushAndRemoveUntil(
                  TaskManager.navigatorKey.currentState!.context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    ),
  );
}