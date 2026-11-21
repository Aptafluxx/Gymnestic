import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gymnestic/core/services/preferences_service.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: 104857600,
  );

  await Get.putAsync(() => PreferencesService().init());

  runApp(const Gymnestic());
}

class Gymnestic extends StatelessWidget {
  const Gymnestic({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: GetMaterialApp(
        title: 'GYMNESTIC',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        initialBinding: InitialBinding(),
      ),
    );
  }
}
