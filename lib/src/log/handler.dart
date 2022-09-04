import 'record.dart';

abstract class Handler {
  void dispatch(Record record);
}
