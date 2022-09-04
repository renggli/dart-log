import '../handler.dart';
import '../record.dart';

class NullHandler extends Handler {
  @override
  void dispatch(Record record) {}
}
