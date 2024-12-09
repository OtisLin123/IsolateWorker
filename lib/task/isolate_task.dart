import 'package:isolate_worker/task/isolate_task_data.dart';

abstract class IsolateTask<T extends IsolateTaskData> {
  dynamic execute(Map<String, dynamic> data);

  T convertExecuteData(Map<String, dynamic> data);
}
