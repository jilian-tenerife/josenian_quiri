import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const String openAIEndpoint =
    'https://api.openai.com/v1/engines/davinci/completions';
const String openAIAuthToken =
    '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';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  List<QuestionAnswerPair> questionAnswerPairs = [];
  bool isGeneratingAnswer = false; // Flag to track answer generation

  @override
  void initState() {
    super.initState();
    loadKnowledgeBase();
  }

  void loadKnowledgeBase() async {
    final String fileContent = await rootBundle.loadString('assets/export.txt');
    final List<QuestionAnswerPair> pairs =
        extractQuestionAnswerPairs(fileContent);
    setState(() {
      questionAnswerPairs = pairs;
    });
  }

  List<QuestionAnswerPair> extractQuestionAnswerPairs(String fileContent) {
    final List<QuestionAnswerPair> pairs = [];
    final List<String> lines = fileContent.split('\n');

    String currentQuestion = '';
    String currentAnswer = '';

    for (final line in lines) {
      final String trimmedLine = line.trim();

      if (isQuestion(trimmedLine)) {
        if (currentQuestion.isNotEmpty && currentAnswer.isNotEmpty) {
          final questionAnswerPair = QuestionAnswerPair(
              question: currentQuestion, answer: currentAnswer);
          pairs.add(questionAnswerPair);
        }

        currentQuestion = trimmedLine;
        currentAnswer = '';
      } else {
        currentAnswer += line + ' ';
      }
    }

    if (currentQuestion.isNotEmpty && currentAnswer.isNotEmpty) {
      final questionAnswerPair =
          QuestionAnswerPair(question: currentQuestion, answer: currentAnswer);
      pairs.add(questionAnswerPair);
    }

    return pairs;
  }

  bool isQuestion(String text) {
    final keywords = ['who', 'what', 'where', 'when', 'why', 'how'];
    final lowercasedText = text.trim().toLowerCase();
    return keywords.any((keyword) => lowercasedText.startsWith(keyword));
  }

  void sendMessage(String text) async {
    setState(() {
      messages.add(Message(text, true));
      isGeneratingAnswer = true; // Set the flag to indicate answer generation
    });

    final response = await http.post(
      Uri.parse(openAIEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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',
      },
      body: jsonEncode({
        'prompt': text,
        'max_tokens': 50,
        'temperature': 0.6,
        'top_p': 1,
        'frequency_penalty': 0,
        'presence_penalty': 0,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final answer = data['choices'][0]['text'];

      setState(() {
        messages.add(Message(answer, false));
        isGeneratingAnswer = false; // Clear the flag after receiving the answer
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        isGeneratingAnswer = false; // Clear the flag if there was an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Josenian Quiri'),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (ctx, index) {
              final message = messages[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: message.isBot
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: message.isBot ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          )),
          if (isGeneratingAnswer) // Display the loading indicator if generating answer
            Center(
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      sendMessage(value);
                    },
                    decoration:
                        InputDecoration(hintText: 'Type your question...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage('Some question');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionAnswerPair {
  final String question;
  final String answer;

  QuestionAnswerPair({required this.question, required this.answer});
}

class Message {
  final String text;
  final bool isBot;

  Message(this.text, this.isBot);
}

void main() {
  runApp(MaterialApp(
    home: ChatScreen(),
  ));
}
