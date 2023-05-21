import 'package:flutter/material.dart';
import 'package:surveyapp/helper/validator_helper.dart';
import 'package:surveyapp/model/survey_api_model.dart';
import 'package:surveyapp/screens/survey_details_screen.dart';
import 'package:surveyapp/service/question_service.dart';
import 'package:surveyapp/utils/constants.dart';

class QuestionAddScreen extends StatefulWidget {
  final Survey survey;

  const QuestionAddScreen({super.key, required this.survey});

  @override
  _QuestionAddScreenState createState() => _QuestionAddScreenState();
}

class _QuestionAddScreenState extends State<QuestionAddScreen> {
  final _questionService = QuestionService();
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String _questionType = AppConstants.questionTypeMcq;
  final List<String> _options = [];
  bool _disableAddOptionButton = false;

  @override
  void initState() {
    super.initState();
    if (_questionType == AppConstants.questionTypeYesNo) {
      _disableAddOptionButton = true;
      _options
          .addAll([AppConstants.questionTypeYes, AppConstants.questionTypeNo]);
    }
  }

  void addOption() {
    setState(() {
      _options.add('');
    });
  }

  void deleteOption(int index) {
    setState(() {
      _options.removeAt(index);
    });
  }

  void updateOption(int index, String value) {
    setState(() {
      _options[index] = value;
    });
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      final question = Question(
        text: _textController.text,
        type: _questionType,
        options: _options,
        id: '',
      );
      final survey = widget.survey
          .copyWith(questions: [...widget.survey.questions, question]);
      await _questionService.addQuestion(survey.id, question);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SurveyDetailsScreen(survey: survey),
        ),
      );
      //Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.questionAddTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: AppConstants.questionLabelText,
                  hintText: AppConstants.questionTitleHint,
                ),
                validator: (value) {
                  return HelperValidator.validateQuestionText(value!);
                },
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              DropdownButtonFormField(
                value: _questionType,
                items: [
                  DropdownMenuItem(
                    value: AppConstants.questionTypeMcq,
                    child: Text(AppConstants.questionTypeMcq),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.questionTypeYesNo,
                    child: Text(AppConstants.questionTypeYesNo),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: AppConstants.questionTypeLabelText,
                ),
                onChanged: (value) {
                  setState(() {
                    _questionType = value.toString();
                    _options.clear();
                    if (_questionType == AppConstants.questionTypeYesNo) {
                      _disableAddOptionButton = true;
                      _options.addAll([
                        AppConstants.questionTypeYes,
                        AppConstants.questionTypeNo
                      ]);
                    } else {
                      _disableAddOptionButton = false;
                    }
                  });
                },
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              Text(AppConstants.optionLabelText),
              ..._options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: option,
                        decoration: InputDecoration(
                          hintText: 'Option ${index + 1}',
                        ),
                        validator: (value) {
                          return HelperValidator.validateOption(value!);
                        },
                        onChanged: (value) => updateOption(index, value),
                      ),
                    ),
                    if (!_disableAddOptionButton &&
                        index == _options.length - 1)
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteOption(index),
                      ),
                  ],
                );
              }),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              Center(
                child: ElevatedButton(
                  onPressed: !_disableAddOptionButton ? addOption : null,
                  child: Text(AppConstants.optionAddTitle),
                ),
              ),
              SizedBox(height: AppConstants.sizedBoxSizesHeight),
              Center(
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: Text(AppConstants.questionAddTitle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
