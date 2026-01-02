import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/widgets/notes/shipment_notes_card.dart';
import 'package:supercycle/features/representative_shipment_details/data/models/rep_note_model.dart';

class RepresentativeShipmentNotesContent extends StatefulWidget {
  final List<ShipmentNoteModel> notes;
  const RepresentativeShipmentNotesContent({super.key, required this.notes});

  @override
  State<RepresentativeShipmentNotesContent> createState() =>
      _RepresentativeShipmentNotesContentState();
}

class _RepresentativeShipmentNotesContentState
    extends State<RepresentativeShipmentNotesContent> {
  List<ShipmentNoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      notes = widget.notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return notes.isEmpty
        ? Center(
            child: Text(
              "لا توجد ملاحظات",
              style: AppStyles.styleRegular16(
                context,
              ).copyWith(color: Colors.grey.shade600),
            ),
          )
        : ListView.builder(
            shrinkWrap:
                true, // مهم جداً: عشان الـ ListView ياخد المساحة اللي يحتاجها بس
            physics:
                const NeverScrollableScrollPhysics(), // نعطل scrolling الـ ListView عشان الـ parent يعمل scroll
            padding: EdgeInsets.zero, // نشيل الـ padding الافتراضي
            itemCount: notes.length,
            itemBuilder: (context, index) {
              return ShipmentNoteCard(note: notes[index]);
            },
          );
  }
}
