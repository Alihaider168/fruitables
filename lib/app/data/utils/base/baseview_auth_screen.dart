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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
      // Dark color for the status bar
      statusBarIconBrightness: Brightness.light,
      // White icons on the status bar
      statusBarBrightness:
          Brightness.dark, // For iOS: sets status bar text and icons to light
    ));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // Customize this per your needs
      child: Scaffold(
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: child!)),
    );
  }
}
