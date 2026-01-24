import 'logger.dart';
import 'record.dart';

/// A handler is responsible for processing log records.
///
/// Handlers are attached to [Logger] instances and are called when a [Record]
/// is dispatched to the logger.
abstract class Handler {
  void dispatch(Record record);
}
