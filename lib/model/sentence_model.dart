class Sentence {
  int id;
  String img;
  String name;
  String sentence;

  Sentence({this.id, this.img, this.name, this.sentence});

  Sentence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    name = json['name'];
    sentence = json['sentence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img'] = this.img;
    data['name'] = this.name;
    data['sentence'] = this.sentence;
    return data;
  }
}
