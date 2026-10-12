import 'package:get/get.dart';
import 'package:gymnestic/features/workout/presentation/controllers/workout_details_controller.dart';

class WorkoutDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkoutDetailsController>(WorkoutDetailsController.new);
  }
}
