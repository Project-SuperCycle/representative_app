import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class NotesContent extends StatefulWidget {
  final List<String> notes;
  final String shipmentID;
  final Function(List<String>) onNotesChanged;

  const NotesContent({
    super.key,
    required this.notes,
    required this.shipmentID,
    required this.onNotesChanged,
  });

  @override
  State<NotesContent> createState() => _NotesContentState();
}

class _NotesContentState extends State<NotesContent> {
  late TextEditingController _notesController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    String initialNotes = widget.notes.join('\n');
    _notesController = TextEditingController(text: initialNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _editNotes() {}

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shadowColor: Colors.grey,
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade300, width: 1.5),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _notesController,
                maxLines: null,
                expands: true,
                textAlign: TextAlign.right,
                style: AppStyles.styleRegular14(context),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 70),
                  hintText: 'اكتب ملاحظاتك هنا...',
                  hintStyle: AppStyles.styleRegular14(
                    context,
                  ).copyWith(color: Colors.grey),
                ),
                onTap: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                onChanged: (value) {
                  widget.onNotesChanged(
                    value.split('\n').where((note) => note.isNotEmpty).toList(),
                  );
                },
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
