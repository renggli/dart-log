import '../handler.dart';
import '../record.dart';

/// A handler that stores log records in a list.
class MemoryHandler extends Handler {
  final List<Record> buffer = [];

  @override
  void dispatch(Record record) => buffer.add(record);
}
