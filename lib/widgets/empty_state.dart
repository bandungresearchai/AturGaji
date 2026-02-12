import 'package:flutter/material.dart';

/// Widget to display when there's no data
class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? actionCallback;
  final String? actionLabel;

  const EmptyState({
    Key? key,
    this.title,
    this.message,
    this.icon,
    this.actionCallback,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 80,
                color: Colors.grey[300],
              ),
            if (icon != null) const SizedBox(height: 16),
            if (title != null)
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            if (title != null) const SizedBox(height: 8),
            if (message != null)
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            if (actionCallback != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: actionCallback,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
