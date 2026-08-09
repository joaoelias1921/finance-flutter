import 'package:flutter/material.dart';

class ValueDisplay extends StatelessWidget {
  final double doubleValue;
  final String formattedValue;
  final Color activeColor;

  const ValueDisplay({
    super.key,
    required this.doubleValue,
    required this.formattedValue,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'NOVO VALOR',
            style: TextStyle(fontSize: 12, letterSpacing: 4),
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: Draggable<double>(
            data: doubleValue,
            dragAnchorStrategy: pointerDragAnchorStrategy,
            feedback: Material(
              color: Colors.transparent,
              child: Transform.translate(
                offset: Offset(-60, -30),
                child: Text(
                  formattedValue,
                  style: TextStyle(
                    fontSize: 50,
                    color: activeColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(opacity: 0.3, child: _buildValueRow()),
            child: _buildValueRow(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Arraste para categorizar',
                style: TextStyle(fontSize: 14, color: Color(0xFF3B82F6)),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_downward, size: 16, color: Color(0xFF3B82F6)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValueRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      spacing: 4,
      children: [
        Text(
          'R\$',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF95B8FF),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedValue,
          style: TextStyle(
            fontSize: 60,
            color: Color(0xFF3B82F6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
