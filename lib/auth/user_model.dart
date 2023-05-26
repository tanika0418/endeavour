class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  //bool confirmed;
  //String role;
  bool profile;
  bool eventPass;
  //bool internshipFair;
  //bool hackathon;
  //String endvrid;
  //String branch;
  String college;
  String libId;
  //String semester;
  String year;
  String course;
  // List<Registered> registered;
 // List registered;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    //required this.confirmed,
    //required this.role,
    required this.profile,
    required this.eventPass,
    //required this.internshipFair,
    //required this.hackathon,
    //required this.endvrid,
    //required this.branch,
    required this.college,
    required this.libId,
    //required this.semester,
    required this.year,
    required this.course,
    //required this.registered,
  });

  factory UserModel.fromMap(Map map) {
    //List<Registered> temp = [];
    //var registeredList = map['registered'] as List;
    //temp = registeredList.map((e) => Registered.fromMap(e)).toList();
    return UserModel(
      id: map['publicId'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['contactNumber'],
      //confirmed: map['confirmed'],
      //role: map['role'],
      profile: map['endeavourUser']["college"]==""?false:true,
      eventPass: map['endeavourUser']['eventPass'],
      //internshipFair: map['internshipFair'],
      //hackathon: map['hackathon'],
      //endvrid: map['endvrid'],
      // college: map.containsKey('college') ? map['college'] : '',
      college: map['endeavourUser']['college'],
      //branch: map.containsKey('branch') ? map['branch'] : '',
      //libId: map.containsKey('libId') ? map['libId'] : '',
      libId: map['endeavourUser']['studentId'],
      //semester: map.containsKey('semester') ? map['semester'] : '',
      year: map['endeavourUser']['year'],
      course: 'B.Tech',
      // registered: temp,
      //registered: map['endeavourUser']['teams']
    );
  }
}

class Registered {
  String event;
  String teams;

  Registered({
    required this.event,
    required this.teams,
  });

  factory Registered.fromMap(Map map) {
    return Registered(
      event: map['event'],
      teams: map['teams'],
    );
  }
}
