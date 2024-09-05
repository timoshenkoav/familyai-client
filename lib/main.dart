import 'package:familyai/ui/cb_app/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() async{
  final binding = WidgetsFlutterBinding.ensureInitialized();
  QR.setUrlStrategy();
  // FlutterError.onError = (errorDetails) {
  //
  // };
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   return true;
  // };
  runApp(const RootPage());
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CbAppPage();
  }
}
