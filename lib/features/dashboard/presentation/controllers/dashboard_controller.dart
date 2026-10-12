import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt currentTabIndex = 0.obs;

  void selectTab(int index) => currentTabIndex.value = index;
}
