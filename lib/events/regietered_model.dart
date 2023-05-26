class RegisteredModel {
  String eventId;
  List<Member> members;
  String teamId;
  //bool isLeader;

  RegisteredModel({
    required this.eventId,
    required this.members,
    required this.teamId,
    // required this.isLeader
  });

  factory RegisteredModel.fromMap(Map map, Map roles) {
    List<Member> tempMember = [];
    List member = map['members'];
    member.forEach((element) {
      bool isLeader = true;
      if (element == member[0]) {
        isLeader = true;
      } else {
        isLeader = false;
      }
      tempMember.add(Member.fromMap(element, isLeader));
    });
    print(tempMember);
    return RegisteredModel(
      eventId: map['eventId'],
      members: tempMember,
      teamId: map['teamId'],
      //isLeader: roles['eventId']
    );
  }
}

class Member {
  //String name;
  String email;
  bool isLeader;
  // String endvrid;
  // String college;
  // String branch;

  Member(
      {
      //required this.name,
      required this.email,
      required this.isLeader
      // required this.endvrid,
      // required this.college,
      // required this.branch,
      });

  factory Member.fromMap(String email, bool isLeader) {
    return Member(
        // name: map['name'],
        email: email,
        isLeader: isLeader
        // endvrid: map['endvrid'],
        // college: map['college'],
        // branch: map['branch'],
        );
  }
}
