import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_manager_app/presentation/utils/assets_path.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AssetsPath.logoSvg,
      width: 100,
      fit: BoxFit.scaleDown,
    );
  }
}