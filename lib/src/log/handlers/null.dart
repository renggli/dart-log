import '../handler.dart';
import '../record.dart';

/// A handler that does nothing.
class NullHandler extends Handler {
  @override
  void dispatch(Record record) {}
}
