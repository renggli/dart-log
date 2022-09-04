import 'dart:async';

import '../handler.dart';
import '../record.dart';

class StreamHandler extends Handler {
  StreamHandler();

  final _controller = StreamController<Record>.broadcast();

  Stream<Record> get stream => _controller.stream;

  @override
  void dispatch(Record record) => _controller.add(record);
}
