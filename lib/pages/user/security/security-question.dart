import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const mainColor = Color.fromRGBO(255, 31, 104, 1.0);
const primaryColor = Color.fromRGBO(35, 38, 38, 1);
const secondaryColor = Color.fromRGBO(41, 45, 46, 1);

class SecurityQuestionsPage extends StatefulWidget {
  const SecurityQuestionsPage({super.key});

  @override
  _SecurityQuestionsPageState createState() => _SecurityQuestionsPageState();
}

class _SecurityQuestionsPageState extends State<SecurityQuestionsPage> {
  final List<String> _questions = [
    "What was the name of your first pet?",
    "What is your mother's maiden name?",
    "What was the name of your elementary school?",
    "What city were you born in?",
  ];

  final List<TextEditingController> _answerControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize a TextEditingController for each question
    for (var i = 0; i < _questions.length; i++) {
      _answerControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to free resources
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveSecurityQuestions() {
    // Implement save logic here
    for (var i = 0; i < _questions.length; i++) {
      print(
          "Question: ${_questions[i]}, Answer: ${_answerControllers[i].text}");
    }
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Security questions saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Questions',
            style: TextStyle(color: mainColor)),
        centerTitle: true,
        backgroundColor: secondaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/icons/chevron-left.svg',
                color: Colors.white, height: 25, width: 25),
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            return _buildQuestionTile(
                _questions[index], _answerControllers[index]);
          },
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: _saveSecurityQuestions,
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
        ),
        child: const Text(
          'Save Questions',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildQuestionTile(String question, TextEditingController controller) {
    return Card(
      color: secondaryColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Your Answer',
                labelStyle: const TextStyle(color: Colors.white),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
