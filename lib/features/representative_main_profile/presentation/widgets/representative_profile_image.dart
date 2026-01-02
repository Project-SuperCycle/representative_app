import 'package:flutter/material.dart';

class RepresentativProfileImage extends StatelessWidget {
  const RepresentativProfileImage({super.key, required this.logoPath});

  final String logoPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(6),
          child: Image.asset(
            logoPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.person,
                size: 70,
                color: Color(0xFF10B981),
              );
            },
          ),
        ),
      ),
    );
  }
}
