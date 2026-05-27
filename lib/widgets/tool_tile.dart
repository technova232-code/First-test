import 'package:flutter/material.dart';
import '../models/tool.dart';

class ToolTile extends StatelessWidget {
  final Tool tool;
  final VoidCallback onCopy;
  const ToolTile({super.key, required this.tool, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tool.name),
      subtitle: Text(tool.installCommand, style: const TextStyle(fontSize: 12)),
      trailing: ElevatedButton.icon(
        icon: const Icon(Icons.copy),
        label: const Text('نسخ كود التثبيت'),
        onPressed: onCopy,
      ),
    );
  }
}
