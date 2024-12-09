<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

IsolateWorker system, which allows for executing computational tasks in separate isolates. The tasks and their respective data are passed between isolates, ensuring non-blocking execution for heavy computations. The system supports task registration, data serialization, and handling task-specific data classes.

## Features
Task Implementations (e.g., FibonacciTask): Concrete implementations of tasks that provide specific functionality (e.g., calculating Fibonacci numbers).

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

Execute Task
```dart
IsolateWorker worker = IsolateWorker();

final fibonacciResult = await worker.init(
  tasks: {
    'fibonacci': FibonacciTask(),
    'uppercase': UppercaseTask(),
  },
);

await worker.executeTask<int>(
  'fibonacci',
  FibonacciTaskData(45),
);
```

Implementation Task
```dart
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
```
