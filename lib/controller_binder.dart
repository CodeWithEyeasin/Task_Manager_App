import 'package:get/get.dart';
import 'package:task_manager_app/presentation/controllers/sign_in_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SignInController());
  }

}