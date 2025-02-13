import 'dart:io';

import 'package:log/log.dart';

final logger =
    Logger('example')
      ..dispatchToParents = ((record) => false)
      ..addHandler(SinkHandler(stdout, printer: basicPrinter));

Future<void> main() async {
  globalLogLevel = Level.all;

  final syslog = SyslogHandler();
  await syslog.open();
  logger.addHandler(syslog);

  logger.trace('Application is loading');
  logger.debug('Application is starting');
  logger.info('Application is running');
  logger.warning('Application is stalling');
  sleep(const Duration(seconds: 1));
  logger.error('Application is stopping');
  logger.fatal('Application is terminating');
}
