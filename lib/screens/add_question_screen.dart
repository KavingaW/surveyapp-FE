// import 'package:flutter/material.dart';
//
// import '../model/question_api_response.dart';
// import '../service/question_service.dart';
// import '../utils/constants.dart';
//
// class QuestionAddScreen extends StatefulWidget {
//   final String surveyId;
//
//   QuestionAddScreen({required this.surveyId});
//
//   @override
//   _QuestionAddScreenState createState() => _QuestionAddScreenState();
// }
//
// class _QuestionAddScreenState extends State<QuestionAddScreen> {
//   late String _surveyId;
//   QuestionService qestionServie = new QuestionService();
//
//   final TextEditingController _textController = TextEditingController();
//   String _selectedType = 'MCQ';
//   List<String> _options = [];
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _surveyId = widget.surveyId;
//     });
//   }
//
//   void _addOption(String option) {
//     setState(() {
//       _options.add(option);
//     });
//   }
//
//   void _deleteOption(int index) {
//     setState(() {
//       _options.removeAt(index);
//     });
//   }
//
//   void _editOption(int index, String option) {
//     setState(() {
//       _options[index] = option;
//     });
//   }
//
//   _submitQuestion() {
//     final question = Question(
//         id: '',
//         text: _textController.text,
//         type: _selectedType,
//         options: _options
//
//     );
//     qestionServie.addQuestion(TextFile.token, _surveyId, question);
//     Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Question'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   "Enter your question",
//                 )),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 controller: _textController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your question text',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Text('Question Type'),
//                   DropdownButton(
//                     value: _selectedType,
//                     items: [
//                       DropdownMenuItem(
//                         value: 'MCQ',
//                         child: Text('Multiple Choice'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'YESNO',
//                         child: Text('Yes/No'),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedType = value.toString();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Enter an option',
//                             border: OutlineInputBorder(),
//                           ),
//                           onSubmitted: (value) {
//                             _addOption(value);
//                             _textController.clear();
//                           },
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: () {
//                           _addOption(_textController.text);
//                           _textController.clear();
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: _options.length,
//                     itemBuilder: (context, index) {
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller:
//                                   TextEditingController(text: _options[index]),
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                               ),
//                               onChanged: (value) {
//                                 _editOption(index, value);
//                               },
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete),
//                             onPressed: () {
//                               _deleteOption(index);
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _submitQuestion(),
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//  _submitQuestion() {
// }

import 'package:flutter/material.dart';
import 'package:surveyapp/model/survey_api_response.dart';
import 'package:surveyapp/service/question_service.dart';
import 'package:surveyapp/utils/constants.dart';

import '../service/survey_service.dart';
class QuestionAddScreen extends StatefulWidget {
  final Survey survey;

  QuestionAddScreen({required this.survey});

  @override
  _QuestionAddScreenState createState() => _QuestionAddScreenState();
}

class _QuestionAddScreenState extends State<QuestionAddScreen> {

  QuestionService questionService = QuestionService();
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  String _questionType = 'MCQ';
  final List<String> _options = [];
  bool _disableAddOptionButton = false;

  @override
  void initState() {
    super.initState();
    if (_questionType == 'YES/NO') {
      _disableAddOptionButton = true;
      _options.addAll(['Yes', 'No']);
    }
  }

  void _addOption() {
    setState(() {
      _options.add('');
    });
  }

  void _deleteOption(int index) {
    setState(() {
      _options.removeAt(index);
    });
  }

  void _updateOption(int index, String value) {
    setState(() {
      _options[index] = value;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final question = Question(
        text: _textController.text,
        type: _questionType,
        options: _options, id: '',
      );
      final survey = widget.survey.copyWith(questions: [...widget.survey.questions, question]);
      questionService.addQuestion(TextFile.token, survey.id,question);
      //await SurveyService().updateSurvey(survey);
      Navigator.pop(context);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Add Question'),
  //     ),
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             TextFormField(
  //               controller: _textController,
  //               decoration: InputDecoration(
  //                 labelText: 'Question',
  //                 hintText: 'Enter the question',
  //               ),
  //               validator: (value) {
  //                 if (value!.isEmpty) {
  //                   return 'Please enter the question';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             DropdownButtonFormField(
  //               value: _questionType,
  //               items: [
  //                 DropdownMenuItem(
  //                   child: Text('MCQ'),
  //                   value: 'MCQ',
  //                 ),
  //                 DropdownMenuItem(
  //                   child: Text('YES/NO'),
  //                   value: 'YES/NO',
  //                 ),
  //               ],
  //               decoration: InputDecoration(
  //                 labelText: 'Question Type',
  //               ),
  //               onChanged: (value) {
  //                 setState(() {
  //                   _questionType = value.toString();
  //                 });
  //               },
  //             ),
  //             SizedBox(height: 16),
  //             Text('Options'),
  //             ..._options.asMap().entries.map((entry) {
  //               final index = entry.key;
  //               final option = entry.value;
  //               return Row(
  //                 children: [
  //                   Expanded(
  //                     child: TextFormField(
  //                       initialValue: option,
  //                       decoration: InputDecoration(
  //                         hintText: 'Option ${index + 1}',
  //                       ),
  //                       validator: (value) {
  //                         if (value!.isEmpty) {
  //                           return 'Please enter an option';
  //                         }
  //                         return null;
  //                       },
  //                       onChanged: (value) => _updateOption(index, value),
  //                     ),
  //                   ),
  //                   IconButton(
  //                     icon: Icon(Icons.delete),
  //                     onPressed: () => _deleteOption(index),
  //                   ),
  //                 ],
  //               );
  //             }),
  //             SizedBox(height: 16),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: _addOption,
  //                 child: Text('Add Option'),
  //               ),
  //             ),
  //             SizedBox(height: 16),
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: _submitForm,
  //                 child: Text('Add Question'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
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
                  labelText: 'Question',
                  hintText: 'Enter the question',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the question';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: _questionType,
                items: [
                  DropdownMenuItem(
                    child: Text('MCQ'),
                    value: 'MCQ',
                  ),
                  DropdownMenuItem(
                    child: Text('YES/NO'),
                    value: 'YES/NO',
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Question Type',
                ),
                onChanged: (value) {
                  setState(() {
                    _questionType = value.toString();
                    _options.clear();
                    if (_questionType == 'YES/NO') {
                      _disableAddOptionButton = true;
                      _options.addAll(['Yes', 'No']);
                    } else {
                      _disableAddOptionButton = false;
                    }
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Options'),
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
                          if (value!.isEmpty) {
                            return 'Please enter an option';
                          }
                          return null;
                        },
                        onChanged: (value) => _updateOption(index, value),
                      ),
                    ),
                    if (!_disableAddOptionButton && index == _options.length - 1)
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteOption(index),
                      ),
                  ],
                );
              }),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: !_disableAddOptionButton ? _addOption : null,
                  child: Text('Add Option'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Question'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

