class Sponsor {
  int priority;
  String title;
  List<SponsorTile> items;

  Sponsor({required this.priority, required this.title, required this.items});

  factory Sponsor.fromMap(Map map) {
    List<SponsorTile> temp=[];
    for(Map item in map['items']){
      // item.forEach((key,value){
        temp.add(SponsorTile.fromMap(item));
      // });
    }
    return Sponsor(
      priority: map['priority'],
      title: map['title'],
      items: temp,
    );
  }
}

class SponsorTile {
  String name;
  String link;
  String cat;
  String imgUri;
  int tile;

  SponsorTile({
    required this.name,
    required this.link,
    required this.imgUri,
    required this.cat,
    required this.tile,
  });

  factory SponsorTile.fromMap(Map map) {
    return SponsorTile(
      name: map['name'],
      link: map['url'],
      imgUri: map['img'],
      cat: map['category'],
      tile: map['span'],
    );
  }
}
