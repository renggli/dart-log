// ignore_for_file: avoid_print

import 'package:more/printer.dart';

import '../handler.dart';
import '../printers.dart';
import '../record.dart';

class PrintHandler extends Handler {
  PrintHandler({Printer<Record>? printer}) : printer = printer ?? basicPrinter;

  final Printer<Record> printer;

  @override
  void dispatch(Record record) => print(printer.print(record));
}
