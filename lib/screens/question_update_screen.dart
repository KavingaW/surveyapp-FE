import 'package:flutter/material.dart';
import 'package:surveyapp/screens/survey_details_screen.dart';
import 'package:surveyapp/service/question_service.dart';
import 'package:surveyapp/utils/constants.dart';
import '../model/survey_api_response.dart';
import '../widgets/delete_response_widget.dart';
import '../widgets/delete_widget.dart';

// class QuestionUpdateScreen extends StatefulWidget {
//   final Question question;
//
//   QuestionUpdateScreen({required this.question});
//
//   @override
//   _QuestionUpdateScreenState createState() => _QuestionUpdateScreenState();
// }
//
// class _QuestionUpdateScreenState extends State<QuestionUpdateScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Question'),
//       ),
//     );
//   }
// }

class QuestionUpdateScreen extends StatefulWidget {
  final Question question;

  QuestionUpdateScreen({required this.question});

  @override
  _QuestionUpdateScreenState createState() => _QuestionUpdateScreenState();
}

// class _QuestionUpdateScreenState extends State<QuestionUpdateScreen> {
//   QuestionService questionService = QuestionService();
//   late TextEditingController _textController;
//   late String _questionType;
//   late List<String> _options;
//
//   @override
//   void initState() {
//     super.initState();
//     _textController = TextEditingController(text: widget.question.text);
//     _questionType = widget.question.type;
//     _options = List<String>.from(widget.question.options);
//     if (_questionType == 'YES/NO') {
//       _options = ['Yes', 'No'];
//     }
//   }
//
//   void _updateQuestion() async {
//     Question question = Question(
//       id: widget.question.id,
//       text: _textController.text,
//       type: _questionType,
//       options: _options,
//     );
//
//     questionService.updateQuestion(TextFile.token,question.id,question);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Question'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 labelText: 'Question',
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: DropdownButtonFormField<String>(
//               value: _questionType,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _questionType = newValue!;
//                 });
//               },
//               items: <String>[
//                 'MCQ',
//                 'YES/NO',
//               ].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               decoration: InputDecoration(
//                 labelText: 'Question Type',
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Options',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 ..._options.map((option) {
//                   return Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: TextEditingController(text: option),
//                           onChanged: (value) {
//                             // _options[_options.indexOf(option)] = value;
//                             if(_questionType == 'YES/NO'){
//                               _options = ['Yes','No'];
//                             }else{
//                               _options=[];
//                             }
//                           },
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           setState(() {
//                             _options.remove(option);
//                           });
//                         },
//                       ),
//                     ],
//                   );
//                 }),
//                 SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _options.add('');
//                     });
//                   },
//                   child: Text('Add More Option'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           _updateQuestion();
//         },
//         child: Icon(Icons.save),
//       ),
//     );
//   }
// }

class _QuestionUpdateScreenState extends State<QuestionUpdateScreen> {
  QuestionService questionService = QuestionService();
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
    _canAddMoreOptions = _questionType != 'YES/NO';
    if (_questionType == 'YES/NO') {
      _options = ['Yes', 'No'];
    }
  }

  void _updateQuestion() async {
    Question question = Question(
      id: widget.question.id,
      text: _textController.text,
      type: _questionType,
      options: _options,
    );

    questionService.updateQuestion(TextFile.token, question.id, question);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Question'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => DeleteConfirmationDialog(
                  onConfirm: () {
                    questionService.deleteQuestion(
                        TextFile.token, widget.question.id);
                    DeleteResponseMessage.show(
                      context,
                      'Question has been deleted successfully.',
                    );
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Question',
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: _questionType,
              onChanged: (String? newValue) {
                setState(() {
                  _questionType = newValue!;
                  _canAddMoreOptions = _questionType != 'YES/NO';
                  if (_questionType == 'YES/NO') {
                    _options = ['Yes', 'No'];
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
                labelText: 'Question Type',
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
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
                        icon: Icon(Icons.delete),
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
                SizedBox(height: 8),
                if (_canAddMoreOptions)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _options.add('');
                      });
                    },
                    child: Text('Add More Option'),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateQuestion();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
