class EventModel {
  int index;
  bool isExternal;
  String tagline;
  bool showPrice;
  String name;
  String id;
  String eventId;
  String imgUri;
  bool isOpen;
  int maxMemberCount;
  int minMemberCount;
  String desc;
  int price;
  String mongoId;
  int discount;
  bool isDis;
  List<EventDetailTile> content;
  List<FaqTile> faq;

  EventModel({
    required this.index,
    required this.isExternal,
    required this.tagline,
    required this.showPrice,
    required this.name,
    required this.id,
    required this.eventId,
    required this.imgUri,
    required this.isOpen,
    required this.maxMemberCount,
    required this.minMemberCount,
    required this.desc,
    required this.price,
    required this.mongoId,
    required this.discount,
    required this.isDis,
    required this.content,
    required this.faq
  });

  factory EventModel.fromMap(Map map) {
    List<EventDetailTile> tempcontent =[];
    Map c = map['content'];
    c.forEach((key, value){
      tempcontent.add(EventDetailTile.fromMap(value as Map));
    });
    List<FaqTile> tempfaq =[];
    Map f = map['faq'];
    f.forEach((key, value){
      tempfaq.add(FaqTile.fromMap(value as Map));
    });


    return EventModel(
      index: map['index'],
      isExternal: map['isExternal'],
      tagline: map['tagline'],
      showPrice: map['showPrice'],
      name: map['name'],
      id: map['id'],
      eventId: map['eventId'],
      imgUri: map['imgUri'],
      isOpen: map['isOpen'],
      maxMemberCount: map['maxMemberCount'],
      minMemberCount: map['minMemberCount'],
      desc: map['desc'],
      price: map['price'],
      mongoId: map['mongoId'],
      discount: map['discount'],
      isDis: map['isDis'],
      content: tempcontent,
      faq: tempfaq
    );
  }
}

class EventDetailTile {
  String title;
  String body;

  EventDetailTile({
    required this.title,
    required this.body,
  });

  factory EventDetailTile.fromMap(Map map) {
    return EventDetailTile(
      title: map['title'],
      body: map['body'],
    );
  }
}

class FaqTile {
  String que;
  String ans;

  FaqTile({
    required this.que,
    required this.ans,
  });

  factory FaqTile.fromMap(Map map) {
    return FaqTile(
      que: map['question'],
      ans: map['answer'],
    );
  }
}
