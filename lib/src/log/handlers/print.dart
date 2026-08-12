// ignore_for_file: avoid_print

import 'package:more/printer.dart';

import '../handler.dart';
import '../printers.dart';
import '../record.dart';

/// A handler that prints log records to stdout.
class PrintHandler extends Handler {
  new({Printer<Record>? printer}) : printer = printer ?? basicPrinter;

  final Printer<Record> printer;

  @override
  void dispatch(Record record) => print(printer.print(record));
}
