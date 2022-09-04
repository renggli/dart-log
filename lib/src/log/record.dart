import 'package:more/printer.dart';

import 'level.dart';
import 'logger.dart';

class Record with ToStringPrinter {
  Record({
    required this.logger,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
  });

  /// The logger that created this log record.
  final Logger logger;

  /// The log level of this log record.
  final Level level;

  /// The message of this log record.
  final String message;

  /// The timestamp this record was created at.
  final DateTime created = DateTime.now();

  /// An optional error object.
  final Object? error;

  /// An optional stack trace.
  final StackTrace? stackTrace;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(logger.fullName, name: 'logger')
    ..addValue(level.label, name: 'level')
    ..addValue(message, name: 'message')
    ..addValue(created, name: 'created')
    ..addValue(error, name: 'error', omitNull: true)
    ..addValue(stackTrace, name: 'stackTrace', omitNull: true);
}
