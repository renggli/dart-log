import 'package:more/printer.dart';

import 'record.dart';

/// Prints the name of the logger.
final namePrinter = Printer<Record>.pluggable((record) => record.logger.name);

/// Prints the full name of the logger.
final fullNamePrinter = Printer<Record>.pluggable(
  (record) => record.logger.fullName,
);

/// Prints the level of the record.
final levelPrinter = Printer<Record>.pluggable((record) => record.level.label);

/// Prints the message of the record.
final messagePrinter = Printer<Record>.pluggable((record) => record.message);

/// Prints the creation time of the record.
final createdPrinter = DateTimePrinter.iso8601().onResultOf<Record>(
  (record) => record.created,
);

/// A basic printer that prints level, message and creation time.
final basicPrinter = <Printer<Record>>[
  levelPrinter,
  const Printer.literal(': '),
  messagePrinter,
  createdPrinter.around(' [', ']'),
].toPrinter();
