import 'package:flutter/material.dart';

class CategoryItem {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class CategorySelector extends StatelessWidget {
  final bool isExpense;
  final Function(CategoryItem category, double amount)? onCategoryDropped;

  const CategorySelector({
    super.key,
    required this.isExpense,
    this.onCategoryDropped,
  });

  List<CategoryItem> get _currentCategories {
    if (isExpense) {
      return [
        CategoryItem(
          id: 'essential',
          label: 'ESSENCIAL',
          icon: Icons.interests,
          color: Color(0xFF3B82F6),
        ),
        CategoryItem(
          id: 'fun',
          label: 'ENTRETENIMENTO',
          icon: Icons.sports_esports,
          color: Color(0xFFD97706),
        ),
        CategoryItem(
          id: 'finance',
          label: 'FINANÇAS',
          icon: Icons.analytics,
          color: Color(0xFF10B981),
        ),
        CategoryItem(
          id: 'diverse',
          label: 'DIVERSOS',
          icon: Icons.redeem,
          color: Color(0xFFEF4444),
        ),
      ];
    }
    return [
      CategoryItem(
        id: 'salary',
        label: 'SALÁRIO',
        icon: Icons.payments,
        color: Color(0xFF10B981),
      ),
      CategoryItem(
        id: 'freelance',
        label: 'FREELANCE',
        icon: Icons.work,
        color: Color(0xFF3B82F6),
      ),
      CategoryItem(
        id: 'investments',
        label: 'RENDIMENTO',
        icon: Icons.trending_up,
        color: Color(0xFF8B5CF6),
      ),
      CategoryItem(
        id: 'other_income',
        label: 'OUTROS',
        icon: Icons.add_card,
        color: Color(0xFF6B7280),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _currentCategories.map((item) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DragTarget<double>(
                  onAcceptWithDetails: (details) {
                    onCategoryDropped?.call(item, details.data);
                  },
                  builder: (context, candidateData, rejectedData) {
                    final bool isHovered = candidateData.isNotEmpty;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: isHovered ? 84 : 72,
                          height: isHovered ? 84 : 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color.withValues(
                              alpha: isHovered ? 0.30 : 0.08,
                            ),
                            border: Border.all(
                              color: isHovered
                                  ? item.color
                                  : item.color.withValues(alpha: 0.3),
                              width: isHovered ? 3.5 : 1.5,
                            ),
                            boxShadow: isHovered
                                ? [
                                    BoxShadow(
                                      color: item.color.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            item.icon,
                            color: item.color,
                            size: isHovered ? 38 : 32,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: isHovered ? item.color : Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
