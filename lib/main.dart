import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '0';
  String _operator = '';
  double? _firstOperand;
  bool _waitingForSecondOperand = false;

  void _clear() {
    setState(() {
      _input = '0';
      _operator = '';
      _firstOperand = null;
      _waitingForSecondOperand = false;
    });
  }

  void _appendValue(String value) {
    setState(() {
      if (_waitingForSecondOperand) {
        _input = value == '.' ? '0.' : value;
        _waitingForSecondOperand = false;
      } else {
        if (_input == '0' && value != '.') {
          _input = value;
        } else {
          if (value == '.' && _input.contains('.')) return;
          _input += value;
        }
      }
    });
  }

  void _toggleSign() {
    setState(() {
      if (_input.startsWith('-')) {
        _input = _input.substring(1);
      } else {
        _input = '-$_input';
      }
    });
  }

  void _percent() {
    setState(() {
      double num = double.tryParse(_input) ?? 0;
      _input = (num / 100).toString();
      if (_input.endsWith('.0')) {
        _input = _input.replaceAll('.0', '');
      }
    });
  }

  void _setOperator(String operator) {
    setState(() {
      _firstOperand = double.tryParse(_input);
      _operator = operator;
      _waitingForSecondOperand = true;
    });
  }

  void _calculate() {
    double secondOperand = double.tryParse(_input) ?? 0;
    double result = 0;

    if (_firstOperand != null) {
      switch (_operator) {
        case '+':
          result = _firstOperand! + secondOperand;
          break;
        case '-':
          result = _firstOperand! - secondOperand;
          break;
        case '*':
          result = _firstOperand! * secondOperand;
          break;
        case '/':
          result = secondOperand != 0 ? _firstOperand! / secondOperand : 0;
          break;
      }

      setState(() {
        _input = result.toString().replaceAll(RegExp(r"\.0$"), "");
        _operator = '';
        _firstOperand = null;
        _waitingForSecondOperand = false;
      });
    }
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 24)),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[200],
          elevation: 6,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // borderRadius: text == "7" ? BorderRadius.circular(100) : BorderRadius.circular(12),
          ),
          minimumSize: Size(64, 64),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(20),
                child: Text(
                  _input,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Divider(thickness: 2),
            Expanded(
              flex: 5,
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.all(10),
                children: [
                  _buildButton('C', _clear),
                  _buildButton('±', _toggleSign),
                  _buildButton('%', _percent),
                  _buildButton('+', () => _setOperator('+')),
                  _buildButton('7', () => _appendValue('7')),
                  _buildButton('8', () => _appendValue('8')),
                  _buildButton('9', () => _appendValue('9')),
                  _buildButton('-', () => _setOperator('-')),
                  _buildButton('4', () => _appendValue('4')),
                  _buildButton('5', () => _appendValue('5')),
                  _buildButton('6', () => _appendValue('6')),
                  _buildButton('*', () => _setOperator('*')),
                  _buildButton('1', () => _appendValue('1')),
                  _buildButton('2', () => _appendValue('2')),
                  _buildButton('3', () => _appendValue('3')),
                  _buildButton('/', () => _setOperator('/')),
                  _buildButton('0', () => _appendValue('0')),
                  _buildButton('.', () => _appendValue('.')),
                  _buildButton('=', _calculate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
