library isolate_worker;

import 'dart:async';
import 'dart:isolate';
import 'package:isolate_worker/enum/isolate_worker_status.dart';
import 'package:isolate_worker/task/isolate_task.dart';
import 'package:isolate_worker/task/isolate_task_data.dart';

class IsolateWorker {
  Isolate? _isolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  int _commandId = 0;
  final Map<String, Completer<dynamic>> _completers = {};

  Future<void> init({Map<String, IsolateTask>? tasks}) async {
    _receivePort = ReceivePort();
    _receivePort?.listen(_handleMessage);

    _isolate = await Isolate.spawn(_isolateEntryPoint, {
      'sendPort': _receivePort!.sendPort,
      'tasks': tasks,
    });
  }

  IsolateWorkerStatus getStatus() {
    return _sendPort == null
        ? IsolateWorkerStatus.notInitialized
        : IsolateWorkerStatus.ready;
  }

  void _handleMessage(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
    } else if (message is Map<String, dynamic>) {
      final commandId = message['commandId'] as String;
      final completer = _completers[commandId];

      if (message.containsKey('error')) {
        completer?.completeError(message['error']);
      } else {
        completer?.complete(message['result']);
      }

      _completers.remove(commandId);
    }
  }

  static void _isolateEntryPoint(Map<String, dynamic> args) {
    final receivePort = ReceivePort();
    SendPort sendPort = args['sendPort'];
    Map<String, IsolateTask> tasks = args['tasks'];

    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) {
      if (message is Map<String, dynamic>) {
        try {
          final taskName = message['taskName'] as String;
          final task = tasks[taskName];
          if (task != null) {
            final result = task.execute(message['data']);
            sendPort.send({
              'commandId': message['commandId'],
              'result': result,
            });
          } else {
            throw Exception('未找到任務: $taskName');
          }
        } catch (e) {
          sendPort.send({
            'commandId': message['commandId'],
            'error': e.toString(),
          });
        }
      }
    });
  }

  Future<T> executeTask<T>(String taskName, IsolateTaskData data) async {
    if (_sendPort == null) {
      throw StateError('Isolate 未初始化');
    }

    final commandId = (_commandId++).toString();
    final completer = Completer<T>();
    _completers[commandId] = completer;

    _sendPort?.send({
      'commandId': commandId,
      'taskName': taskName,
      'data': data.toJson(),
    });

    return completer.future;
  }

  void dispose() {
    _isolate?.kill();
    _receivePort?.close();

    for (final completer in _completers.values) {
      completer.completeError('Worker disposed');
    }
    _completers.clear();

    _sendPort = null;
    _isolate = null;
    _receivePort = null;
  }
}
