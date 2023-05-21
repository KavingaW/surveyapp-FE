import 'package:flutter/material.dart';

import 'package:surveyapp/screens/surveys_list_screen.dart';
import 'package:surveyapp/service/question_service.dart';
import 'package:surveyapp/utils/constants.dart';
import '../model/survey_api_model.dart';
import '../widgets/confirmation_response_widget.dart';
import '../widgets/confirmation_widget.dart';

class QuestionUpdateScreen extends StatefulWidget {
  final Question question;

  QuestionUpdateScreen({super.key, required this.question});

  @override
  _QuestionUpdateScreenState createState() => _QuestionUpdateScreenState();
}

class _QuestionUpdateScreenState extends State<QuestionUpdateScreen> {
  late Question _question;
  final _questionService = QuestionService();
  late TextEditingController _textController;
  late String _questionType;
  late List<String> _options;
  late bool _canAddMoreOptions;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.question.text);
    _questionType = widget.question.type;
    _options = List<String>.from(widget.question.options);
    _canAddMoreOptions = _questionType != AppConstants.questionTypeYesNo;
    if (_questionType == AppConstants.questionTypeYesNo) {
      _options = [AppConstants.questionTypeYes, AppConstants.questionTypeNo];
    }
  }

  Future<void> updateQuestion() async {
    Question question = Question(
      id: widget.question.id,
      text: _textController.text,
      type: _questionType,
      options: _options,
    );
    _questionService.updateQuestion(question.id, question);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.updateQuestion),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ConfirmationDialog(
                  onConfirm: () async {
                    await _questionService.deleteQuestion(widget.question.id);
                    ConfirmationResponseMessage.show(
                      context,
                      'Question has been deleted successfully.',
                    );
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurveyListScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  operation: AppConstants.operationDelete,
                  message: AppConstants.messageDelete,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppConstants.sizedBoxSizesHeight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: AppConstants.questionLabelText,
                ),
              ),
            ),
            SizedBox(height: AppConstants.sizedBoxSizesHeight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: _questionType,
                onChanged: (String? newValue) {
                  setState(() {
                    _questionType = newValue!;
                    _canAddMoreOptions =
                        _questionType != AppConstants.questionTypeYesNo;
                    if (_questionType == AppConstants.questionTypeYesNo) {
                      _options = [
                        AppConstants.questionTypeYes,
                        AppConstants.questionTypeNo
                      ];
                    } else {
                      _options = [];
                    }
                  });
                },
                items: <String>[
                  'MCQ',
                  'YES/NO',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: AppConstants.questionTypeLabelText,
                ),
              ),
            ),
            SizedBox(height: AppConstants.sizedBoxSizesHeight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.optionLabelText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppConstants.sizedBoxSizesHeight),
                  ..._options.map((option) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: option),
                            onChanged: (value) {
                              _options[_options.indexOf(option)] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (_questionType == 'MCQ') {
                              setState(() {
                                _options.remove(option);
                              });
                            }
                          },
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: AppConstants.sizedBoxSizesHeight),
                  if (_canAddMoreOptions)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _options.add('');
                          });
                        },
                        child: Text(AppConstants.addMoreOptions),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => ConfirmationDialog(
              onConfirm: () async {
                await updateQuestion();
                ConfirmationResponseMessage.show(
                  context,
                  'Question has been updated successfully.',
                );
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SurveyListScreen(),
                    ),
                    (route) => false);
              },
              operation: AppConstants.operationUpdate,
              message: AppConstants.messageUpdate,
            ),
          );
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
