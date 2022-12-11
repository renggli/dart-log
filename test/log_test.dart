import 'package:log/log.dart';
import 'package:more/comparator.dart';
import 'package:more/functional.dart';
import 'package:test/test.dart';

Matcher isRecord({
  dynamic level = anything,
  dynamic message = anything,
}) =>
    isA<Record>()
        .having((record) => record.level, 'level', level)
        .having((record) => record.message, 'message', message);

void main() {
  final rootHandler = MemoryHandler();
  final root = Logger('log_test')
    ..dispatchToParents = constantFunction1(false)
    ..addHandler(rootHandler);
  final originalGlobalLogLevel = globalLogLevel;
  setUp(() => globalLogLevel = Level.all);
  tearDown(() => rootHandler.buffer.clear());
  tearDownAll(() => globalLogLevel = originalGlobalLogLevel);

  group('constructors', () {
    test('root', () {
      final root = Logger.root;
      expect(root, same(Logger.root));
      expect(root.name, 'dart');
      expect(root.parent, isNull);
      expect(root.dispatchToParents, isNull);
      expect(root.dispatchToHandlers, isNull);
      expect(root.fullName, '');
      expect(root.handlers, isNotEmpty);
    });
    test('child', () {
      final child = Logger('constructors.parent.child');
      expect(child, same(Logger('constructors.parent.child')));
      expect(child.name, 'child');
      expect(child.parent, same(Logger('constructors.parent')));
      expect(child.dispatchToParents, isNull);
      expect(child.dispatchToHandlers, isNull);
      expect(child.fullName, 'constructors.parent.child');
      expect(child.handlers, isEmpty);
    });
  });
  group('levels', () {
    test('ordering', () {
      final levels = [
        Level.all,
        Level.trace,
        Level.debug,
        Level.info,
        Level.warning,
        Level.error,
        Level.fatal,
        Level.off
      ];
      expect(naturalComparator<Level>().isStrictlyOrdered(levels), isTrue);
    });
    test('trace', () {
      root.trace('Trace');
      expect(
          rootHandler.buffer, [isRecord(level: Level.trace, message: 'Trace')]);
    });
    test('debug', () {
      root.debug('Debug');
      expect(
          rootHandler.buffer, [isRecord(level: Level.debug, message: 'Debug')]);
    });
    test('info', () {
      root.info('Info');
      expect(
          rootHandler.buffer, [isRecord(level: Level.info, message: 'Info')]);
    });
    test('warning', () {
      root.warning('Warning');
      expect(rootHandler.buffer,
          [isRecord(level: Level.warning, message: 'Warning')]);
    });
    test('error', () {
      root.error('Error');
      expect(
          rootHandler.buffer, [isRecord(level: Level.error, message: 'Error')]);
    });
    test('fatal', () {
      root.fatal('Fatal');
      expect(
          rootHandler.buffer, [isRecord(level: Level.fatal, message: 'Fatal')]);
    });
  });
  group('parents', () {
    final innerHandler = MemoryHandler();
    final innerLogger = root.getChild('parents')..addHandler(innerHandler);
    tearDown(() {
      innerHandler.buffer.clear();
      innerLogger.dispatchToParents = null;
    });
    test('default', () {
      innerLogger.info('Propagation');
      expect(innerHandler.buffer, [isRecord(message: 'Propagation')]);
      expect(rootHandler.buffer, [isRecord(message: 'Propagation')]);
    });
    test('true', () {
      innerLogger.dispatchToParents = (record) => true;
      innerLogger.info('Propagation');
      expect(innerHandler.buffer, [isRecord(message: 'Propagation')]);
      expect(rootHandler.buffer, [isRecord(message: 'Propagation')]);
    });
    test('false', () {
      innerLogger.dispatchToParents = (record) => false;
      innerLogger.info('Propagation');
      expect(innerHandler.buffer, [isRecord(message: 'Propagation')]);
      expect(rootHandler.buffer, <Record>[]);
    });
    test('dynamic', () {
      innerLogger.dispatchToParents = (record) => record.level >= Level.info;
      innerLogger
        ..info('Propagation')
        ..trace('No propagation');
      expect(innerHandler.buffer, [
        isRecord(message: 'Propagation'),
        isRecord(message: 'No propagation')
      ]);
      expect(rootHandler.buffer, [isRecord(message: 'Propagation')]);
    });
  });
  group('handlers', () {
    final innerHandler = MemoryHandler();
    final innerLogger = root.getChild('handlers')..addHandler(innerHandler);
    tearDown(() {
      innerHandler.buffer.clear();
      innerLogger.level = Level.all;
      innerLogger.dispatchToHandlers = null;
    });
    test('default', () {
      innerLogger.warning('Handled');
      expect(innerHandler.buffer, [isRecord(message: 'Handled')]);
      expect(rootHandler.buffer, [isRecord(message: 'Handled')]);
    });
    test('levels', () {
      innerLogger.level = Level.warning;
      for (final level in [Level.trace, Level.warning, Level.fatal]) {
        innerLogger.log(level, level.label);
      }
      expect(innerHandler.buffer, [
        for (final level in [Level.warning, Level.fatal])
          isRecord(level: level),
      ]);
      expect(rootHandler.buffer, [
        for (final level in [Level.trace, Level.warning, Level.fatal])
          isRecord(level: level),
      ]);
    });
    test('true', () {
      innerLogger.dispatchToHandlers = (record) => true;
      innerLogger.warning('Handled');
      expect(innerHandler.buffer, [isRecord(message: 'Handled')]);
      expect(rootHandler.buffer, [isRecord(message: 'Handled')]);
    });
    test('false', () {
      innerLogger.dispatchToHandlers = (record) => false;
      innerLogger.info('Handled');
      expect(innerHandler.buffer, <Record>[]);
      expect(rootHandler.buffer, [isRecord(message: 'Handled')]);
    });
    test('dynamic', () {
      innerLogger.dispatchToHandlers =
          (record) => !record.message.startsWith('Not');
      innerLogger
        ..warning('Handled')
        ..warning('Not handled');
      expect(innerHandler.buffer, [isRecord(message: 'Handled')]);
      expect(rootHandler.buffer,
          [isRecord(message: 'Handled'), isRecord(message: 'Not handled')]);
    });
    test('multiple', () {
      final innerHandler = MemoryHandler();
      final innerLogger = root.getChild('handlers.multiple')
        ..addHandler(innerHandler)
        ..addHandler(innerHandler);
      innerLogger.info('Repeated');
      expect(innerHandler.buffer,
          [isRecord(message: 'Repeated'), isRecord(message: 'Repeated')]);
      expect(rootHandler.buffer, [isRecord(message: 'Repeated')]);
    });
  });
}
