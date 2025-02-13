import 'package:more/collection.dart';
import 'package:more/functional.dart';
import 'package:more/printer.dart';

import 'config.dart';
import 'handler.dart';
import 'handlers/print.dart';
import 'level.dart';
import 'record.dart';

class Logger with ToStringPrinter implements Handler {
  /// Returns the root logger, or one of its descendants if called with dot-
  /// separated hierarchical name. Multiple calls with the same name will return
  /// the same [Logger].
  ///
  /// The hierarchical name is typically starting with the package name, followed
  /// by directory, file or class names; example names look like `log.handlers` or
  /// `log.handlers.Heap`.
  factory Logger([String? name]) => root.getChild(name);

  /// Internal constructor to create a new logger.
  Logger._(this.name, {this.parent});

  /// Returns the default root logger.
  static final root = Logger._('dart')..addHandler(PrintHandler());

  /// The name of the logger.
  final String name;

  /// The parent logger, if any.
  final Logger? parent;

  /// The child loggers.
  final Map<String, Logger> _children = {};

  /// The handlers on this logger.
  final List<Handler> handlers = [];

  /// Minimum log level required to dispatch to handler, does not affect the
  /// propagation to parents.
  Level level = Level.all;

  /// Predicate to dispatch log records to its handlers. If no predicate is
  /// specified log records are automatically propagated.
  Predicate1<Record>? dispatchToHandlers;

  /// Predicate to dispatch log records to its parent loggers. If no predicate
  /// is specified log records are automatically propagated.
  Predicate1<Record>? dispatchToParents;

  /// The full name of the logger.
  String get fullName {
    final names = <String>[];
    for (
      Logger? current = this;
      current != null && current != root;
      current = current.parent
    ) {
      names.add(current.name);
    }
    return names.reversed.join('.');
  }

  /// Returns a logger which is a descendant of this logger, as determined by
  /// the suffix.
  Logger getChild([String? suffix]) {
    if (suffix == null || suffix.isEmpty) {
      return this;
    }
    final name = suffix.takeTo('.');
    final child = _children.putIfAbsent(
      name,
      () => Logger._(name, parent: this),
    );
    return child.getChild(suffix.skipTo('.'));
  }

  /// Adds a new handler to this logger.
  void addHandler(Handler handler) => handlers.add(handler);

  /// Logs a message with [Level.trace].
  void trace(String message, {Object? error, StackTrace? stackTrace}) =>
      log(Level.trace, message, error: error, stackTrace: stackTrace);

  /// Logs a message with [Level.debug].
  void debug(String message, {Object? error, StackTrace? stackTrace}) =>
      log(Level.debug, message, error: error, stackTrace: stackTrace);

  /// Logs a message with [Level.info].
  void info(String message, {Object? error, StackTrace? stackTrace}) =>
      log(Level.info, message, error: error, stackTrace: stackTrace);

  /// Logs a message with [Level.warning].
  void warning(String message, {Object? error, StackTrace? stackTrace}) =>
      log(Level.warning, message, error: error, stackTrace: stackTrace);

  /// Logs a message with [Level.error].
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      log(Level.error, message, error: error, stackTrace: stackTrace);

  /// Logs a message with [Level.fatal].
  void fatal(String message, {Object? error, StackTrace? stackTrace}) =>
      log(Level.fatal, message, error: error, stackTrace: stackTrace);

  /// Logs a generic [level] and [message], with optional [error] and
  /// [stackTrace].
  void log(
    Level level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Create the log record and dispatch only, if the required level is
    // at least the [globalLogLevel].
    if (globalLogLevel <= level) {
      dispatch(
        Record(
          logger: this,
          level: level,
          message: message,
          error: error,
          stackTrace: stackTrace ?? StackTrace.current,
        ),
      );
    }
  }

  @override
  void dispatch(Record record) {
    // Dispatch the log record to its handlers, if applicable.
    if (handlers.isNotEmpty && level <= record.level) {
      final dispatchToHandlers_ = dispatchToHandlers;
      if (dispatchToHandlers_ == null || dispatchToHandlers_(record)) {
        for (final handler in handlers) {
          handler.dispatch(record);
        }
      }
    }
    // Dispatch the log record to its parent logger, if applicable.
    final parent_ = parent;
    if (parent_ != null) {
      final dispatchToParents_ = dispatchToParents;
      if (dispatchToParents_ == null || dispatchToParents_(record)) {
        parent_.dispatch(record);
      }
    }
  }

  @override
  ObjectPrinter<dynamic> get toStringPrinter =>
      super.toStringPrinter..addValue(fullName, name: 'fullName');
}
