import 'package:checks/checks.dart';
import 'package:log/log.dart';

/// Extension on [Subject] of [Record] providing domain-specific checks.
extension RecordChecks on Subject<Record> {
  /// Extracts the log level.
  Subject<Level> get level => has((r) => r.level, 'level');

  /// Extracts the log message.
  Subject<String> get message => has((r) => r.message, 'message');

  /// Extracts the logger instance.
  Subject<Logger> get logger => has((r) => r.logger, 'logger');

  /// Extracts the timestamp.
  Subject<DateTime> get created => has((r) => r.created, 'created');

  /// Extracts the error object.
  Subject<Object?> get error => has((r) => r.error, 'error');

  /// Extracts the stack trace.
  Subject<StackTrace?> get stackTrace => has((r) => r.stackTrace, 'stackTrace');
}

/// A condition for matching a [Record] within collections.
Condition<Object?> isRecord({Level? level, String? message}) =>
    (Subject<Object?> it) {
      final record = it.isA<Record>();
      if (level != null) record.level.equals(level);
      if (message != null) record.message.equals(message);
    };
