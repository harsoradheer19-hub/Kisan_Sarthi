import 'package:flutter/foundation.dart';

class AdvisoryProvider extends ChangeNotifier {
  String? selectedCategoryId;
  String? selectedCategoryName;
  
  int currentStep = 0;
  List<dynamic> questions = [];
  Map<String, String> userAnswers = {};
  
  bool isLoading = false;
  Map<String, dynamic>? advisoryResult;

  void selectCategory(String id, String name) {
    selectedCategoryId = id;
    selectedCategoryName = name;
    currentStep = 0;
    userAnswers.clear();
    advisoryResult = null;
    notifyListeners();
  }

  void setQuestions(List<dynamic> qList) {
    questions = qList;
    currentStep = 0;
    notifyListeners();
  }

  void answerQuestion(String paramKey, String optionValue) {
    userAnswers[paramKey] = optionValue;
    notifyListeners();
  }

  bool canProceed() {
    if (questions.isEmpty || currentStep >= questions.length) return false;
    final currentQ = questions[currentStep];
    final paramKey = currentQ['param_key'];
    return userAnswers.containsKey(paramKey) && userAnswers[paramKey]!.isNotEmpty;
  }

  void nextStep() {
    if (currentStep < questions.length - 1) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void setResult(Map<String, dynamic> result) {
    advisoryResult = result;
    notifyListeners();
  }
}
