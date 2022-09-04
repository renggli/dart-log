import 'package:more/printer.dart';

import 'record.dart';

final namePrinter = Printer<Record>.pluggable((record) => record.logger.name);
final fullNamePrinter =
    Printer<Record>.pluggable((record) => record.logger.fullName);
final levelPrinter = Printer<Record>.pluggable((record) => record.level.label);
final messagePrinter = Printer<Record>.pluggable((record) => record.message);
final createdPrinter =
    DateTimePrinter.iso8691().onResultOf<Record>((record) => record.created);

final basicPrinter = <Printer<Record>>[
  levelPrinter,
  Printer.literal(': '),
  messagePrinter,
  createdPrinter.around(' [', ']'),
].toPrinter();
