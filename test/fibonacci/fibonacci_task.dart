import 'package:isolate_worker/task/isolate_task.dart';

import 'fibonacci_task_data.dart';

class FibonacciTask implements IsolateTask<FibonacciTaskData> {
  @override
  dynamic execute(data) {
    FibonacciTaskData taskData = convertExecuteData(data);

    final n = taskData.n;
    return _calculateFibonacci(n ?? 0);
  }

  int _calculateFibonacci(int n) {
    if (n <= 1) return n;
    return _calculateFibonacci(n - 1) + _calculateFibonacci(n - 2);
  }

  @override
  FibonacciTaskData convertExecuteData(Map<String, dynamic> data) {
    return FibonacciTaskData.fromJson(data);
  }
}
