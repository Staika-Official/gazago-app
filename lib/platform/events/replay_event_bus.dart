import 'package:rxdart/rxdart.dart';

class ReplayEventBus {
  static final ReplayEventBus _instance = ReplayEventBus();

  static ReplayEventBus get instance {
    return _instance;
  }

  // ReplaySubject will re-emit all past events to new subscribers
  final _eventController = ReplaySubject<dynamic>();

  // Expose stream
  Stream<dynamic> get stream => _eventController.stream;

  // Method to add events
  void addEvent(dynamic event) {
    _eventController.add(event);
  }

  // Dispose method to close the stream
  void dispose() {
    _eventController.close();
  }
}
