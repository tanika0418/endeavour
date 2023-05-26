import 'dart:async';

import 'package:endeavour22/speakers/speaker_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class SpeakerProvider with ChangeNotifier {
  List<SpeakerTile> _allSpeakers = [];
  final _speakerDB = FirebaseDatabase.instance.ref().child('speakers');
  late StreamSubscription<DatabaseEvent> _speakerStream;
  bool _completed = false;

  List<SpeakerTile> get allSpeakers => _allSpeakers;

  bool get completed => _completed;

  SpeakerProvider() {
    _fetchSpeakers();
  }

  void _fetchSpeakers() {
    _speakerStream = _speakerDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _allSpeakers.clear();
        _completed = true;
        notifyListeners();
      } else {
        final _allData = event.snapshot.value as dynamic;
        for (var element in _allData) {
          final data = SpeakerTile.fromMap(element);
          _allSpeakers.add(data);
        }
        _completed = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _speakerStream.cancel();
    super.dispose();
  }
}
