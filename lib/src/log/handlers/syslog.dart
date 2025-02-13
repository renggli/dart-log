import 'dart:async';
import 'dart:io';

import 'package:more/collection.dart';

import '../handler.dart';
import '../level.dart';
import '../record.dart';

enum Facility {
  kern, //	Kernel messages
  user, //	User-level messages
  mail, //	Mail system
  daemon, //	System daemons
  auth, //	Security/authentication messages
  syslog, //	Messages generated internally by syslogd
  lpr, //	Line printer subsystem
  news, //	Network news subsystem
  uucp, //	UUCP subsystem
  cron, //	Cron subsystem
  authpriv, //	Security/authentication messages
  ftp, //	FTP daemon
  ntp, //	NTP subsystem
  security, //	Log audit
  console, //	Log alert
  solaris, //	Scheduling daemon
  local0, //	local0 – local7	Locally used facilities
  local1,
  local2,
  local3,
  local4,
  local5,
  local6,
  local7,
}

enum Priority {
  emergency,
  alert,
  critical,
  error,
  warning,
  notice,
  info,
  debug,
}

class SyslogHandler extends Handler {
  SyslogHandler({this.host = 'localhost', this.port = 514});

  final String host;
  final int port;

  InternetAddress? _address;
  RawDatagramSocket? _socket;

  Future<void> open() async {
    final addresses = await InternetAddress.lookup(host);
    if (addresses.isEmpty) {
      throw FileSystemException('$host:$port not found');
    }
    _address = addresses.first;
    _socket = await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 0);
  }

  Future<void> close() async {
    _socket?.close();
  }

  Facility getFacility(Record record) => Facility.user;

  Priority getPriority(Record record) =>
      record.level <= Level.debug
          ? Priority.debug
          : record.level <= Level.info
          ? Priority.info
          : record.level <= Level.warning
          ? Priority.warning
          : record.level <= Level.error
          ? Priority.error
          : record.level <= Level.fatal
          ? Priority.critical
          : Priority.alert;

  @override
  void dispatch(Record record) {
    final buffer = StringBuffer();
    final facility = getFacility(record);
    final priority = getPriority(record);
    buffer.write('<${8 * facility.index + priority.index}>');
    // buffer.write('1 '); // version
    // final isoTimestamp = DateTimePrinter.iso8691().print(record.created);
    // buffer.write('$isoTimestamp ');
    // var appName = record.logger.fullName;
    // if (appName == '') appName = record.logger.name;
    // buffer.write('$appName ');
    // buffer.write('[$pid]: ');
    var message = record.message;
    if (message == '') {
      if (record.error != null) {
        message = record.error!.toString().takeTo('\n');
      } else if (record.stackTrace != null) {
        message = record.stackTrace!.toString().takeTo('\n');
      } else {
        message = 'n/a';
      }
    }
    buffer.write(message.take(1024));
    buffer.write('\u0000');
    _socket?.send(buffer.toString().codeUnits, _address!, port);
  }
}
