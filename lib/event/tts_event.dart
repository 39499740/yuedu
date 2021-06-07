import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();

class TTSServiceEvent {
  Map<String, dynamic> ttsEvent;

  TTSServiceEvent(this.ttsEvent);
}
