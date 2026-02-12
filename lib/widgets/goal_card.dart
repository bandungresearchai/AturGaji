import 'package:flutter/material.dart';
import '../models/saving_goal.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

/// Widget for displaying a saving goal in a card format
class GoalCard extends StatelessWidget {
  final SavingGoal goal;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = goal.progressPercentage;
    final category = GoalCategory.getById(goal.category);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                category.color.withOpacity(0.1),
                category.color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category and menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category icon and name
                  Row(
                    children: [
                      Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Menu button
                  if (onDelete != null)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Hapus'),
                          onTap: onDelete,
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress / 100 > 1 ? 1 : progress / 100,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 100 ? Colors.green : category.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${AppHelpers.formatCurrency(goal.currentAmount)} / ${AppHelpers.formatCurrency(goal.targetAmount)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${progress.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: category.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Status and days left
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppHelpers.getGoalStatus(goal.currentAmount, goal.targetAmount),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: goal.isCompleted ? Colors.green : Colors.blue,
                    ),
                  ),
                  if (goal.targetDate != null)
                    Text(
                      '${AppHelpers.daysUntilDate(goal.targetDate!)} hari lagi',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
