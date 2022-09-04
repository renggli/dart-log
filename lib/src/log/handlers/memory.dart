import '../handler.dart';
import '../record.dart';

class MemoryHandler extends Handler {
  final List<Record> buffer = [];

  @override
  void dispatch(Record record) => buffer.add(record);
}
