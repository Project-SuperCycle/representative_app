import 'package:flutter/material.dart';

class TraderProfileImage extends StatelessWidget {
  const TraderProfileImage({super.key, required this.logoPath});

  final String logoPath;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const CircleBorder(),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: ClipOval(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(2.5),
            child: Image.asset(
              logoPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.store, size: 50, color: Colors.blue);
              },
            ),
          ),
        ),
      ),
    );
  }
}
