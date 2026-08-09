import 'package:flutter/material.dart';

class LargeKeyboard extends StatelessWidget {
  final Function(String key)? onKeyPressed;
  final VoidCallback? onDeletePressed;

  const LargeKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        _buildKeyboardRow(['1', '2', '3']),
        _buildKeyboardRow(['4', '5', '6']),
        _buildKeyboardRow(['7', '8', '9']),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            _buildKeyboardButton('0', width: 184),
            _buildKeyboardButton('delete'),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: keys.map((key) => _buildKeyboardButton(key)).toList(),
    );
  }

  Widget _buildKeyboardButton(String key, {double width = 88}) {
    final isDelete = key == 'delete';

    return Material(
      color: !isDelete ? Colors.grey[300] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (isDelete) {
            onDeletePressed?.call();
            return;
          }
          onKeyPressed?.call(key);
        },
        child: Container(
          width: width,
          height: 60,
          alignment: Alignment.center,
          child: isDelete
              ? Icon(
                  Icons.backspace_outlined,
                  color: Colors.redAccent,
                  size: 24,
                )
              : Text(
                  key,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
        ),
      ),
    );
  }
}
