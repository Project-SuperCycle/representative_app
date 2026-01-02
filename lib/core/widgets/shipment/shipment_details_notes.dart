import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/notes/shipment_notes_card.dart';
import 'package:supercycle/core/widgets/shipment_add_note_sheet.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/rep_note_model.dart';

class ShipmentDetailsNotes extends StatefulWidget {
  final List<ShipmentNoteModel> notes;
  final String shipmentID;

  const ShipmentDetailsNotes({
    super.key,
    required this.shipmentID,
    required this.notes,
  });

  @override
  State<ShipmentDetailsNotes> createState() => _ShipmentDetailsNotesState();
}

class _ShipmentDetailsNotesState extends State<ShipmentDetailsNotes> {
  List<ShipmentNoteModel> notes = [];
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notes = widget.notes;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void _editNotes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ShipmentAddNoteSheet(
          shipmentId: widget.shipmentID,
          noteController: noteController,
        );
      },
    ).then((_) {
      // Check if note was added after sheet closes
      if (noteController.text.isNotEmpty) {
        setState(() {
          notes.add(
            ShipmentNoteModel(
              authorRole: 'trader_uncontracted',
              content: noteController.text,
              createdAt: DateTime.now(),
            ),
          );
        });
        noteController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shadowColor: Colors.grey,
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 240,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300, width: 1.5),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 20,
                top: 10,
                bottom: 8,
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  // Edit icon
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryColor,
                    ),
                    icon: const Icon(Icons.mode_edit_outline_rounded, size: 25),
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

            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: widget.notes.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد ملاحظات",
                          style: AppStyles.styleRegular16(
                            context,
                          ).copyWith(color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.notes.length,
                        itemBuilder: (context, index) {
                          return ShipmentNoteCard(note: widget.notes[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
