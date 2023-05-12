class Question{
  String id;
  String text;
  String type;
  List<String> options;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options
    });

  factory Question.fromJson(Map<String, dynamic> json) {
    var optionList = json['options'] as List;
    List<String> options =
    optionList.map((item) => item.toString()).toList();

    return Question(
        id: json['id'],
        text: json['text'],
        type: json['type'],
        options: options
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'type': type,
    'options': options
  };
}