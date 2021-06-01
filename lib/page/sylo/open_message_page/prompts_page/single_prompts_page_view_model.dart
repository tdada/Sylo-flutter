import 'package:testsylo/model/prompt_item.dart';
import 'package:testsylo/page/sylo/open_message_page/prompts_page/single_prompts_page.dart';

class SinglePromptsPageViewModel {
  SinglePromptsPageState state;
  List<PromptItem> listPrompt = List();
  List<String> listPromptQuestions = List();


  SinglePromptsPageViewModel(SinglePromptsPageState state){
    this.state = state;
    listPrompt.add(PromptItem(text: "Opening message", isCheck: false));
    listPrompt.add(PromptItem(text: "Planning", isCheck: false));
    listPrompt.add(PromptItem(text: "Birth", isCheck: false));

    listPromptQuestions.add("How much do you love your child?");
    listPromptQuestions.add("Why have you created a Sylo for them?");
    listPromptQuestions.add("What type of messages can they look forward to hearing from you in this Sylo?");
    listPromptQuestions.add("Are there any key things your child will learn when viewing the TimePosts within this Sylo?");
  }
}