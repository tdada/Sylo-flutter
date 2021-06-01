class QuestionsModel {
  String question;
  String answer;
  bool isChecked;

  QuestionsModel({this.question, this.answer, this.isChecked = false});

}

class HelpInfoModel {
  String title;
  List<QuestionsModel> queList;

  HelpInfoModel({this.title, this.queList});

}