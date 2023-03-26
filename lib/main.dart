import 'package:flutter/material.dart';
import 'package:quiztime/question_service.dart';
import 'package:cool_alert/cool_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final sAsk = "Ask";
  final sTrue = "True";
  final sFalse = "False";
  final sMarPad = const EdgeInsets.all(8.0);
  final mMarPad = const EdgeInsets.all(16.0);
  final green = Colors.green;
  final red = Colors.red;
  final bground = Colors.black26;
  final QuestionService questionService = QuestionService();
  List<Icon> result = [];

  void answerCheck(bool value) {
    if (questionService.getAnswer() == value) {
      result.add(Icon(Icons.check, color: green));
    } else {
      result.add(Icon(Icons.close, color: red));
    }
  }

  void finishCheck() {
    if (questionService.getFinish()) {
      result = [];
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "All questions were answered!",
      );
      questionService.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: sMarPad,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              flex: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: bground,
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: sMarPad,
                padding: mMarPad,
                child: Center(
                    child: Text(
                  questionService.getQuestion(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: sMarPad,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      shape: const RoundedRectangleBorder()),
                  onPressed: () {
                    setState(() {
                      answerCheck(true);
                      questionService.nextQuestion();
                      finishCheck();
                    });
                  },
                  child: Text(sTrue,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 20)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: sMarPad,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      shape: const RoundedRectangleBorder()),
                  onPressed: () {
                    setState(() {
                      answerCheck(false);
                      questionService.nextQuestion();
                      finishCheck();
                    });
                  },
                  child: Text(sFalse,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 20)),
                ),
              ),
            ),
            Row(
              children: result,
            )
          ]),
        ),
      ),
    );
  }
}
