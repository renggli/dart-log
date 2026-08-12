import 'package:more/printer.dart';

import '../handler.dart';
import '../record.dart';

/// A handler that writes log records to a [StringSink].
class SinkHandler extends Handler {
  new(this.sink, {Printer<Record>? printer})
    : printer = printer ?? const Printer.standard();

  final StringSink sink;
  final Printer<Record> printer;

  @override
  void dispatch(Record record) => sink.writeln(printer.print(record));
}
