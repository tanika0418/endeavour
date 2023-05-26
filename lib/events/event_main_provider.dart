import 'dart:async';
import 'dart:collection';

import 'package:endeavour22/events/event_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EventMainProvider with ChangeNotifier {
  // final List<EventModel> _corpEvents = [];
  // final List<EventModel> _funEvents = [];
  // final List<EventModel> _spsEvents = [];
  final List<EventModel> _Events = [];
  bool _isEventsOpen = true;
  bool _completed = false;
  final _eventDB =
      FirebaseDatabase.instance.ref().child('eventMain').orderByChild('index');
  late StreamSubscription<DatabaseEvent> _eventStream;

  // List<EventModel> get corpEvents => _corpEvents;
  // List<EventModel> get funEvents => _funEvents;
  // List<EventModel> get spsEvents => _spsEvents;
  List<EventModel> get Events => _Events;

  bool get completed => _completed;

  bool get isEventsOpen => _isEventsOpen;

  void fetchEvents() {
    // _corpEvents.clear();
    // _funEvents.clear();
    // _spsEvents.clear();
    print('hereeeeeeeeeeeeee');
    _Events.clear();
    _eventStream = _eventDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _isEventsOpen = false;
        _completed = true;
        notifyListeners();
      } else {
        final _allData = new SplayTreeMap<String, dynamic>.from(
            event.snapshot.value as Map, (a, b) => a.compareTo(b));
        _allData.forEach((key, value) {
          final data = EventModel.fromMap(value);
          _Events.add(data);
        });
        _isEventsOpen = true;
        _completed = true;
        notifyListeners();
      }
    });
  }

  // String getEventName(String id) {
  //   if (_Events.length == 0) {
  //      fetchEvents;
  //   }
  //   print(_Events);
  //   EventModel res = _Events.firstWhere((element) => element.mongoId == id);
  //   return res.name;
  // }

  @override
  void dispose() {
    _eventStream.cancel();
    super.dispose();
  }
}
