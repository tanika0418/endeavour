import 'dart:async';

import 'package:endeavour22/sponsors/sponsor_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class SponsorsProvider with ChangeNotifier {
  List<Sponsor> _sponsors = [];
  final _sponsorDB = FirebaseDatabase.instance.ref().child('sponsors');
  late StreamSubscription<DatabaseEvent> _sponsorsStream;
  bool _completed = false;
  int _spCount = 0;

  List<Sponsor> get allSponsors => _sponsors;

  bool get completed => _completed;
  int get spCount => _spCount;

  SponsorsProvider() {
    fetchSponsors();
  }

  void fetchSponsors() {
    _sponsorsStream = _sponsorDB.onValue.listen((event) {
     // print("maiiiiiiii ${event.snapshot.value as dynamic}");
      if (event.snapshot.value == null) {
        _sponsors.clear();
        _completed = true;
        notifyListeners();
      } else {
        // final _allData = new SplayTreeMap.from(
        //     event.snapshot.value as dynamic);
            // (a, b) => a.compareTo(b));
            // _allData.forEach((key, value) {
            //   final data = SponsorTile.fromMap(value);
            //   _sponsors.add(data);
            // });
        // _sponsors = _allData.values.map((e) {
        //   final data = SponsorTile.fromMap(Map<String, dynamic>.from(e));
        //   return data;
        // }).toList();
        final _allData = event.snapshot.value as dynamic;
        print('sta $_allData');
        for(Map element in _allData){
          final data = Sponsor.fromMap(element);
          _sponsors.add(data);
          print(data);
        }
        _spCount = _sponsors.length;
       // print('staaaaaa $_sponsors');
        _completed = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _sponsorsStream.cancel();
    super.dispose();
  }
}
