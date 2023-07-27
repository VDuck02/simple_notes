class NoteModel {
  final int? id;
  final String? title;
  final String? desc;
  final String? dateandtime;

  const NoteModel({
    this.id,
    this.title,
    this.desc,
    this.dateandtime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'desc': this.desc,
      'dateandtime': this.dateandtime,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int,
      title: map['title'] as String,
      desc: map['desc'] as String,
      dateandtime: map['dateandtime'] as String,
    );
  }
}