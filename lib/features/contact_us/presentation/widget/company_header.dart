import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/contact_strings.dart';

class CompanyHeader extends StatelessWidget {
  final bool isArabic;
  final String? logoUrl;
  final String? companyName;

  const CompanyHeader({
    super.key,
    required this.isArabic,
    this.logoUrl,
    this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _buildLogo(),
              const SizedBox(width: 16),
              Expanded(child: _buildCompanyInfo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: logoUrl != null
            ? Image.network(
                logoUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackIcon(),
              )
            : _buildFallbackIcon(),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(Icons.store, size: 30, color: Colors.green.shade600);
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          companyName ?? 'SUPER CYCLE',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          ContactStrings.get('agentInfo', isArabic),
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }
}
