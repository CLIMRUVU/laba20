import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Text Preview App',
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _textController = TextEditingController();
  double _fontSize = 16.0;

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // robo
              Image.network(
                'https://emojiisland.com/cdn/shop/products/Robot_Emoji_Icon_abe1111a-1293-4668-bdf9-9ceb05cff58e_large.png?v=1571606090',
                height: 50,
              ),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center), // Повідомлення в діалозі
            ],
          ),
          actions: [
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Закрити діалог
                },
                child: const Text('Ok'),
              ),
            ),
          ],
        );
      },
    );
  }

// Перехід до другого екрану з передачею даних
  void _navigateToPreview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(
          text: _textController.text, // Текст з поля
          fontSize: _fontSize, // Розмір шрифту
        ),
      ),
    );

    // Обробка результату після повернення з другого екрану
    if (result == 'ok') {
      _showDialog('Cool!');
    } else if (result == 'cancel') {
      _showDialog('Let’s try something else');
    } else {
      _showDialog('Don\'t know what to say');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Text Previewer', textAlign: TextAlign.center),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Поле для вводу тексту
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'text', // Текст для мітки
                  border: OutlineInputBorder(),
                ),
                maxLines: null, // Дозволяє вводити кілька рядків
              ),
              const SizedBox(height: 8),
              // Підказка під полем, вирівняна по лівому краю
              const Align(
                alignment: Alignment.centerLeft, // Вирівнюємо по лівому краю
                child: Text(
                  'Enter your text', // Підказка
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Font Size: ${_fontSize.toInt()}'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Slider(
                      value: _fontSize,
                      min: 10,
                      max: 50,
                      divisions: 8, // кроки для слайдеру
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value; // Оновлення розміру шрифту
                        });
                      },
                    ),
                  ),
                ],
              ),
              // Кнопка для переходу на екран попереднього перегляду
              ElevatedButton(
                onPressed: _navigateToPreview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// другий екран
class SecondScreen extends StatelessWidget {
  final String text; // Текст для показу на другому екрані
  final double fontSize; // Розмір шрифту для тексту

  const SecondScreen({super.key, required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Фон заголовка
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: fontSize), // Застосовуємо заданий розмір шрифту
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Кнопки для повернення до першого екрану
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionButton(context, 'Ok', 'ok', Colors.deepPurple, Colors.white),
                const SizedBox(width: 10),
                _actionButton(context, 'Cancel', 'cancel', Colors.white, Colors.deepPurple),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Функція для створення кнопок з передачею результату
  ElevatedButton _actionButton(BuildContext context, String label, String result, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, result);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        side: result == 'cancel' ? const BorderSide(color: Colors.deepPurple) : null,
      ),
      child: Text(label),
    );
  }
}
