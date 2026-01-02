import 'package:flutter/material.dart';
import 'package:supercycle/core/models/shipment_trader_model.dart';
import 'package:supercycle/core/services/storage_services.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/sign_in/data/models/logined_user_model.dart';
import 'package:supercycle/generated/l10n.dart';

class ClientDataContent extends StatefulWidget {
  final ShipmentTraderModel? trader;
  const ClientDataContent({super.key, this.trader});

  @override
  State<ClientDataContent> createState() => _ClientDataContentState();
}

class _ClientDataContentState extends State<ClientDataContent> {
  ShipmentTraderModel? entity;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    if (widget.trader != null) {
      setState(() {
        entity = widget.trader;
      });
      return;
    }
    LoginedUserModel? user = await StorageServices.getUserData();
    setState(() {
      entity = ShipmentTraderModel(
        bussinessName: user!.bussinessName!,
        rawBusinessType: user.rawBusinessType!,
        bussinessAdress: user.bussinessAdress!,
        doshMangerName: user.doshMangerName!,
        doshMangerPhone: user.doshMangerPhone!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Business Info Section
        _buildSectionHeader(
          icon: Icons.business,
          title: 'معلومات الجهة',
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        ModernDataRow(
          icon: Icons.store,
          label: S.of(context).entity_name,
          value: entity?.bussinessName,
          iconColor: Colors.blue,
        ),
        const SizedBox(height: 12),
        ModernDataRow(
          icon: Icons.category,
          label: S.of(context).entity_type,
          value: entity?.rawBusinessType,
          iconColor: Colors.purple,
        ),
        const SizedBox(height: 12),
        ModernDataRow(
          icon: Icons.location_on,
          label: S.of(context).entity_address,
          value: entity?.bussinessAdress,
          iconColor: Colors.red,
        ),

        const SizedBox(height: 24),

        // Administrator Info Section
        _buildSectionHeader(
          icon: Icons.person,
          title: 'معلومات المسؤول',
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        ModernDataRow(
          icon: Icons.person_outline,
          label: S.of(context).administrator_name,
          value: entity?.doshMangerName,
          iconColor: Colors.green,
        ),
        const SizedBox(height: 12),
        ModernDataRow(
          icon: Icons.phone,
          label: S.of(context).administrator_phone,
          value: entity?.doshMangerPhone,
          iconColor: Colors.orange,
        ),

        const SizedBox(height: 24),

        // Payment Info Section
        _buildSectionHeader(
          icon: Icons.payment,
          title: 'معلومات الدفع',
          color: Colors.teal,
        ),
        const SizedBox(height: 16),
        ModernDataRow(
          icon: Icons.calendar_today,
          label: S.of(context).start_date,
          value: '15 Mar 2020',
          iconColor: Colors.indigo,
        ),
        const SizedBox(height: 12),
        ModernDataRow(
          icon: Icons.account_balance,
          label: S.of(context).payment_method,
          value: 'تحويل بنكي',
          iconColor: Colors.teal,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

class ModernDataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color iconColor;

  const ModernDataRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: AppStyles.styleMedium14(
                context,
              ).copyWith(fontWeight: FontWeight.w600, color: Colors.grey[800]),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value ?? 'غير محدد',
              style: AppStyles.styleMedium14(
                context,
              ).copyWith(color: Colors.grey[700], height: 1.4),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
