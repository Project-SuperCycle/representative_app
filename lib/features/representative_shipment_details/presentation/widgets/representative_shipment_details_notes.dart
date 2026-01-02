import 'package:flutter/material.dart';
import 'package:supercycle/core/models/single_shipment_model.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/shipment_add_note_sheet.dart';

class RepresentativeShipmentDetailsNotes extends StatefulWidget {
  final SingleShipmentModel shipment;
  const RepresentativeShipmentDetailsNotes({super.key, required this.shipment});

  @override
  State<RepresentativeShipmentDetailsNotes> createState() =>
      _RepresentativeShipmentDetailsNotesState();
}

class _RepresentativeShipmentDetailsNotesState
    extends State<RepresentativeShipmentDetailsNotes> {
  List<String> notes = [];
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _editNotes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ShipmentAddNoteSheet(
          shipmentId: widget.shipment.id,
          noteController: noteController,
        );
      },
    );
    noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shadowColor: Colors.grey,
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300, width: 1.5),
        ),
        child: Stack(
          children: [
            // Content area positioned below the header
            Positioned(
              top: 60, // Increased to accommodate header
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: widget.shipment.repNotes.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد ملاحظات",
                          style: AppStyles.styleRegular16(
                            context,
                          ).copyWith(color: Colors.grey.shade600),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.shipment.repNotes
                              .map(
                                (note) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    "🟢 ${note.content}",
                                    style: AppStyles.styleRegular16(
                                      context,
                                    ).copyWith(height: 1.5),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ),
            ),
            // Header overlay
            Positioned(
              top: 10,
              left: 15,
              right: 20,
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  // Edit icon
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryColor,
                    ),
                    icon: Icon(Icons.mode_edit_outline_rounded, size: 25),
                    onPressed: _editNotes,
                  ),
                  const Spacer(),
                  Text(
                    'ملاحظات :',
                    style: AppStyles.styleSemiBold16(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
