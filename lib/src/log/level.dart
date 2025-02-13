import 'package:more/comparator.dart';

/// The different log levels describe the importance of log events.
class Level with CompareOperators<Level> implements Comparable<Level> {
  /// Constructs a log level with a given priority and label.
  const Level(this.priority, this.label)
    : assert(0 < priority && priority < 10000);

  /// Internal constructor for marker log levels.
  const Level._(this.priority, this.label);

  /// Marker level used to enable all logging.
  static const all = Level._(0, 'all');

  /// Used to demonstrate step by step execution of code that can be ignored
  /// during standard operation, but may be useful in debugging sessions.
  static const trace = Level(1000, 'trace');

  /// Used for events considered to be useful during debugging when more
  /// granular information is needed.
  static const debug = Level(2000, 'debug');

  /// Used for purely informative events that can be ignored during normal
  /// operations.
  static const info = Level(3000, 'info');

  /// Used to identify unexpected behavior inside an application, but that does
  /// not affect normal operations.
  static const warning = Level(4000, 'warning');

  /// Used to identify a problem that prevents an operation from successfully
  /// completing.
  static const error = Level(5000, 'error');

  /// Used to identify a severe problem that prevents the application from
  /// working correctly.
  static const fatal = Level(6000, 'fatal');

  /// Marker level used to disable all logging.
  static const off = Level._(10000, 'off');

  /// The importance of the log level.
  final int priority;

  /// A human readable label of the log level.
  final String label;

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      other is Level && priority == other.priority;

  @override
  int get hashCode => priority;

  @override
  int compareTo(Level other) => priority.compareTo(other.priority);
}
