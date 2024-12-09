import 'package:isolate_worker/task/isolate_task_data.dart';

class UppercaseTaskData implements IsolateTaskData {
  String? text;

  UppercaseTaskData(this.text);

  UppercaseTaskData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {'text': text};
  }
}
