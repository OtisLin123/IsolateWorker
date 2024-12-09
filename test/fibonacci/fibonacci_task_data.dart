import 'package:isolate_worker/task/isolate_task_data.dart';

class FibonacciTaskData extends IsolateTaskData {
  int? n;

  FibonacciTaskData(this.n);

  FibonacciTaskData.fromJson(Map<String, dynamic> json) {
    n = json['n'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {'n': n};
  }
}
