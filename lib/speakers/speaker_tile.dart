class SpeakerTile {
  String name;
  String desc;
  //String tag;
  String imgUri;
  String liP;

  SpeakerTile({
    required this.name,
    required this.desc,
    //required this.tag,
    required this.imgUri,
    required this.liP,
  });

  factory SpeakerTile.fromMap(Map map) {
    return SpeakerTile(
      name: map['name'],
      desc: map['content'],
      //tag: map['tag'],
      imgUri: map['img'],
      liP: map['url'],
    );
  }
}
