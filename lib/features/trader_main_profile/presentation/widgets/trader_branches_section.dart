import 'package:flutter/material.dart';
import 'package:supercycle/core/models/trader_branch_model.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/features/trader_main_profile/presentation/widgets/trader_branchs_section/trader_branchs_chart.dart';

class TraderBranchesSection extends StatefulWidget {
  const TraderBranchesSection({super.key, required this.branches});

  final List<TraderBranchModel> branches;

  @override
  State<TraderBranchesSection> createState() => _TraderBranchesSectionState();
}

class _TraderBranchesSectionState extends State<TraderBranchesSection> {
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _isListView
            ? _buildBranchesList()
            : TraderBranchsChart(branches: widget.branches),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("الفروع المتعاونة", style: AppStyles.styleSemiBold18(context)),
        Row(
          children: [
            _buildViewToggleButton(Icons.list, true),
            _buildViewToggleButton(Icons.bar_chart, false),
          ],
        ),
      ],
    );
  }

  Widget _buildViewToggleButton(IconData icon, bool isListButton) {
    final isActive = _isListView == isListButton;
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? AppColors.primaryColor : Colors.grey,
        size: 25,
      ),
      onPressed: () => setState(() => _isListView = isListButton),
    );
  }

  Widget _buildBranchesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.branches.length,
      itemBuilder: (context, index) {
        final branch = widget.branches[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showBranchDetails(branch),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: _decorBox(),
              child: Row(
                children: [
                  Icon(
                    Icons.store_outlined,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBranchInfo(branch)),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _decorBox() => BoxDecoration(
    color: AppColors.primaryColor.withAlpha(25),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.primaryColor.withAlpha(100),
      width: 1.5,
    ),
  );

  Widget _buildBranchInfo(TraderBranchModel branch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          branch.branchName,
          style: AppStyles.styleSemiBold16(
            context,
          ).copyWith(color: AppColors.primaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "كمية التوريدات: ${branch.deliveryVolume} كجم",
          style: AppStyles.styleSemiBold12(
            context,
          ).copyWith(color: AppColors.subTextColor),
        ),
      ],
    );
  }

  void _showBranchDetails(TraderBranchModel branch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BranchDetailsSheet(branch: branch),
    );
  }
}

class _BranchDetailsSheet extends StatelessWidget {
  const _BranchDetailsSheet({required this.branch});

  final TraderBranchModel branch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("تفاصيل الفرع", style: AppStyles.styleSemiBold18(context)),
            const SizedBox(height: 24),
            _DetailRow(Icons.store, "اسم الفرع", branch.branchName),
            _DetailRow(Icons.location_on, "عنوان الفرع", branch.address),
            _DetailRow(Icons.person, "اسم المسؤول", branch.contactName),
            _DetailRow(Icons.phone, "رقم تواصل المسؤول", branch.contactPhone),
            _DetailRow(
              Icons.inventory_2,
              "حجم التوريدات",
              "${branch.deliveryVolume} كجم",
            ),
            _DetailRow(
              Icons.schedule,
              "ميعاد التسليم",
              _getDeliveryDaysText(branch.deliverySchedule),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.category, color: AppColors.primaryColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "الأنواع المتعامل بها",
                          style: AppStyles.styleSemiBold12(
                            context,
                          ).copyWith(color: AppColors.subTextColor),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: branch.recyclableTypes.map((type) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.primaryColor.withAlpha(100),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                type,
                                style: AppStyles.styleSemiBold12(
                                  context,
                                ).copyWith(color: AppColors.primaryColor),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "إغلاق",
                  style: AppStyles.styleSemiBold16(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method لتحويل shipmentDays لأسماء الأيام
  String _getDeliveryDaysText(List<int> deliverySchedule) {
    const Map<int, String> dayNames = {
      0: 'السبت',
      1: 'الأحد',
      2: 'الإثنين',
      3: 'الثلاثاء',
      4: 'الأربعاء',
      5: 'الخميس',
      6: 'الجمعة',
    };

    if (deliverySchedule.isEmpty) return 'غير محدد';

    return deliverySchedule
        .map((day) => dayNames[day] ?? '')
        .where((day) => day.isNotEmpty)
        .join(', ');
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyles.styleSemiBold12(
                    context,
                  ).copyWith(color: AppColors.subTextColor),
                ),
                const SizedBox(height: 4),
                Text(value, style: AppStyles.styleSemiBold14(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
