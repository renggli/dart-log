import 'package:more/printer.dart';

import '../handler.dart';
import '../record.dart';

class SinkHandler extends Handler {
  SinkHandler(this.sink, {Printer<Record>? printer})
      : printer = printer ?? const Printer.standard();

  final StringSink sink;
  final Printer<Record> printer;

  @override
  void dispatch(Record record) => sink.writeln(printer.print(record));
}
