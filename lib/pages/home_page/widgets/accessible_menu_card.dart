import 'package:flutter/material.dart';
import 'package:project_real/models/menu_item.dart';

class AccessibleMenuCard extends StatelessWidget {
  final MenuItem item;

  const AccessibleMenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${item.title}, ${item.subtitle}. Tombol.',
      hint: 'Ketuk untuk membuka fitur ${item.title}',
      button: true,
      container: true,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, item.route),
          child: Container(
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: 40, color: Colors.black54),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
