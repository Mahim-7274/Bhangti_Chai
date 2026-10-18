import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00796B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00796B),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          primary: const Color(0xFF00796B),
        ),
        useMaterial3: true,
      ),
      home: const VangtiChaiScreen(),
    );
  }
}

class VangtiChaiScreen extends StatefulWidget {
  const VangtiChaiScreen({super.key});

  @override
  State<VangtiChaiScreen> createState() => _VangtiChaiScreenState();
}

class _VangtiChaiScreenState extends State<VangtiChaiScreen> {
  String _enteredAmountStr = '';

  int get _amount => int.tryParse(_enteredAmountStr) ?? 0;

  Map<int, int> get _changeBreakdown {
    final denominations = [500, 100, 50, 20, 10, 5, 2, 1];
    final breakdown = <int, int>{};
    int remaining = _amount;

    for (final note in denominations) {
      if (remaining <= 0) {
        breakdown[note] = 0;
      } else {
        breakdown[note] = remaining ~/ note;
        remaining %= note;
      }
    }
    return breakdown;
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'CLEAR') {
        _enteredAmountStr = '';
      } else {
        // Limit string length to 9 digits to prevent integer overflow
        if (_enteredAmountStr.length >= 9) return;

        if (_enteredAmountStr.isEmpty && key == '0') {
          // Keep empty if starting with 0
          return;
        }
        _enteredAmountStr += key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'VangtiChai',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section showing entered amount
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                _enteredAmountStr.isEmpty
                    ? 'Taka:'
                    : 'Taka: $_enteredAmountStr',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Main content area adapting to screen orientation
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: isLandscape
                    ? _buildLandscapeContent(_changeBreakdown)
                    : _buildPortraitContent(_changeBreakdown),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Portrait Layout: 1-column note table on left, 3-column keypad on right
  Widget _buildPortraitContent(Map<int, int> change) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Side: Single column notes table
        Expanded(
          flex: 4,
          child: _NotesTablePortrait(change: change),
        ),
        const SizedBox(width: 16),
        // Right Side: 3-column numeric keypad
        Expanded(
          flex: 6,
          child: _KeypadPortrait(onKeyPress: _onKeyPress),
        ),
      ],
    );
  }

  // Landscape Layout: 2-column note table on left, 4-column keypad on right
  Widget _buildLandscapeContent(Map<int, int> change) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Side: Two-column notes table
        Expanded(
          flex: 5,
          child: _NotesTableLandscape(change: change),
        ),
        const SizedBox(width: 16),
        // Right Side: 4-column numeric keypad
        Expanded(
          flex: 5,
          child: _KeypadLandscape(onKeyPress: _onKeyPress),
        ),
      ],
    );
  }
}

// Single-column list of notes breakdown for Portrait mode
class _NotesTablePortrait extends StatelessWidget {
  final Map<int, int> change;

  const _NotesTablePortrait({required this.change});

  @override
  Widget build(BuildContext context) {
    final notes = [500, 100, 50, 20, 10, 5, 2, 1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: notes.map((note) {
        final count = change[note] ?? 0;
        return Text(
          '$note: $count',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        );
      }).toList(),
    );
  }
}

// Two-column list of notes breakdown for Landscape mode
class _NotesTableLandscape extends StatelessWidget {
  final Map<int, int> change;

  const _NotesTableLandscape({required this.change});

  @override
  Widget build(BuildContext context) {
    final leftNotes = [500, 100, 50, 20];
    final rightNotes = [10, 5, 2, 1];

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: leftNotes.map((note) {
              final count = change[note] ?? 0;
              return Text(
                '$note: $count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rightNotes.map((note) {
              final count = change[note] ?? 0;
              return Text(
                '$note: $count',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// 3-column Numeric Keypad for Portrait Mode
class _KeypadPortrait extends StatelessWidget {
  final ValueChanged<String> onKeyPress;

  const _KeypadPortrait({required this.onKeyPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _KeypadButton(label: '1', flex: 1, onTap: () => onKeyPress('1')),
              _KeypadButton(label: '2', flex: 1, onTap: () => onKeyPress('2')),
              _KeypadButton(label: '3', flex: 1, onTap: () => onKeyPress('3')),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _KeypadButton(label: '4', flex: 1, onTap: () => onKeyPress('4')),
              _KeypadButton(label: '5', flex: 1, onTap: () => onKeyPress('5')),
              _KeypadButton(label: '6', flex: 1, onTap: () => onKeyPress('6')),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _KeypadButton(label: '7', flex: 1, onTap: () => onKeyPress('7')),
              _KeypadButton(label: '8', flex: 1, onTap: () => onKeyPress('8')),
              _KeypadButton(label: '9', flex: 1, onTap: () => onKeyPress('9')),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _KeypadButton(label: '0', flex: 1, onTap: () => onKeyPress('0')),
              _KeypadButton(label: 'CLEAR', flex: 2, onTap: () => onKeyPress('CLEAR')),
            ],
          ),
        ),
      ],
    );
  }
}

// 4-column Numeric Keypad for Landscape Mode
class _KeypadLandscape extends StatelessWidget {
  final ValueChanged<String> onKeyPress;

  const _KeypadLandscape({required this.onKeyPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              _KeypadButton(label: '1', flex: 1, onTap: () => onKeyPress('1')),
              _KeypadButton(label: '2', flex: 1, onTap: () => onKeyPress('2')),
              _KeypadButton(label: '3', flex: 1, onTap: () => onKeyPress('3')),
              _KeypadButton(label: '4', flex: 1, onTap: () => onKeyPress('4')),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _KeypadButton(label: '5', flex: 1, onTap: () => onKeyPress('5')),
              _KeypadButton(label: '6', flex: 1, onTap: () => onKeyPress('6')),
              _KeypadButton(label: '7', flex: 1, onTap: () => onKeyPress('7')),
              _KeypadButton(label: '8', flex: 1, onTap: () => onKeyPress('8')),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              _KeypadButton(label: '9', flex: 1, onTap: () => onKeyPress('9')),
              _KeypadButton(label: '0', flex: 1, onTap: () => onKeyPress('0')),
              _KeypadButton(label: 'CLEAR', flex: 2, onTap: () => onKeyPress('CLEAR')),
            ],
          ),
        ),
      ],
    );
  }
}

// Individual Keypad Button with custom flex width and styling
class _KeypadButton extends StatelessWidget {
  final String label;
  final int flex;
  final VoidCallback onTap;

  const _KeypadButton({
    required this.label,
    required this.flex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          color: const Color(0xFFDCDCDC),
          borderRadius: BorderRadius.circular(2.0),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(2.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 0.8),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
