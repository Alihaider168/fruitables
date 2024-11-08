import '../../core/app_export.dart';

class BaseviewAuthScreen extends StatelessWidget {
  const BaseviewAuthScreen(
      {super.key,
      this.child,
      this.closeApp,
      this.backgroundColor,
      this.navigationColor});

  final Widget? child;
  final bool? closeApp;
  final Color? backgroundColor;
  final Color? navigationColor;

  @override
  Widget build(BuildContext context) {
    Utils.setUIOverlay();
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: child!));
  }
}
