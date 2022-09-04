import 'src/log/handlers/print.dart';
import 'src/log/logger.dart';

export 'src/log/config.dart';
export 'src/log/handler.dart';
export 'src/log/handlers/memory.dart';
export 'src/log/handlers/null.dart';
export 'src/log/handlers/print.dart';
export 'src/log/handlers/sink.dart';
export 'src/log/handlers/stream.dart';
export 'src/log/level.dart';
export 'src/log/printers.dart';
export 'src/log/record.dart';

/// Internal state holding the root of the standard logging hierarchy.
final _root = Logger('dart')..addHandler(PrintHandler());

/// Returns the root logger if called without an argument, or one of its
/// descendants if called with dot-separated hierarchical name. Multiple calls
/// with the same name will return the same [Logger].
///
/// The hierarchical name is typically starting with the package name, followed
/// by directory, file or class names; example names look like `log.handlers.MemoryHandler` or
/// `more.collection.Heap`.
Logger getLogger([String? name]) => _root.getChild(name);
