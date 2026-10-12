import 'package:get/get.dart';
import 'package:gymnestic/features/workouts/presentation/controllers/workout_details_controller.dart';

class WorkoutDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkoutDetailsController>(WorkoutDetailsController.new);
  }
}
