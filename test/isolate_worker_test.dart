import 'package:flutter_test/flutter_test.dart';
import 'package:isolate_worker/enum/isolate_worker_status.dart';

import 'package:isolate_worker/isolate_worker.dart';

import 'fibonacci/fibonacci_task.dart';
import 'fibonacci/fibonacci_task_data.dart';
import 'uppercase/uppercase_task.dart';
import 'uppercase/uppercase_task_data.dart';

void main() {
  test('task should be success.', () async {
    IsolateWorker worker = IsolateWorker();
    await worker.init(
      tasks: {
        'fibonacci': FibonacciTask(),
        'uppercase': UppercaseTask(),
      },
    );

    while (worker.getStatus() != IsolateWorkerStatus.ready) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final fibonacciResult = await worker.executeTask<int>(
      'fibonacci',
      FibonacciTaskData(45),
    );
    expect(fibonacciResult, 1134903170);

    final uppercaseResult = await worker.executeTask<String>(
      'uppercase',
      UppercaseTaskData('abc'),
    );
    expect(uppercaseResult, 'ABC');
  });
}
