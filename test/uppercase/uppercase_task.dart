import 'package:isolate_worker/task/isolate_task.dart';

import 'uppercase_task_data.dart';

class UppercaseTask implements IsolateTask<UppercaseTaskData> {
  @override
  UppercaseTaskData convertExecuteData(Map<String, dynamic> data) {
    return UppercaseTaskData.fromJson(data);
  }

  @override
  dynamic execute(Map<String, dynamic> data) {
    UppercaseTaskData taskData = convertExecuteData(data);
    return taskData.text?.toUpperCase();
  }
}
