import 'level.dart';

/// All log events below the global log level are ignored. By default only
/// [Level.warning] and other higher priority events are processed.
///
/// Example:
///
/// ```dart
/// globalLogLevel = Level.all;
/// ```
Level globalLogLevel = Level.warning;
