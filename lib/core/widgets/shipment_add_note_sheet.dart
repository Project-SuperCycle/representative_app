import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supercycle/core/cubits/add_notes_cubit/add_notes_cubit.dart';
import 'package:supercycle/core/cubits/add_notes_cubit/add_notes_state.dart';
import 'package:supercycle/core/helpers/custom_loading_indicator.dart';
import 'package:supercycle/core/helpers/custom_snack_bar.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';
import 'package:supercycle/core/models/create_notes_model.dart';

class ShipmentAddNoteSheet extends StatefulWidget {
  final String shipmentId;
  final TextEditingController noteController;
  const ShipmentAddNoteSheet({
    super.key,
    required this.shipmentId,
    required this.noteController,
  });

  @override
  State<ShipmentAddNoteSheet> createState() => _ShipmentAddNoteSheetState();
}

class _ShipmentAddNoteSheetState extends State<ShipmentAddNoteSheet> {
  @override
  void dispose() {
    super.dispose();
  }

  void _addNote({required CreateNotesModel note, required String shipmentId}) {
    BlocProvider.of<AddNotesCubit>(
      context,
    ).addNotes(notes: note, shipmentId: shipmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'إضافة ملاحظة جديدة',
                style: AppStyles.styleSemiBold16(
                  context,
                ).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // TextField
              TextField(
                controller: widget.noteController,
                maxLines: 4,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'اكتب الملاحظة هنا...',
                  hintStyle: AppStyles.styleRegular16(
                    context,
                  ).copyWith(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                style: AppStyles.styleRegular16(context),
              ),
              SizedBox(height: 24),

              // Buttons Row
              BlocConsumer<AddNotesCubit, AddNotesState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is AddNotesSuccess) {
                    GoRouter.of(context).pop();
                  }

                  if (state is AddNotesFailure) {
                    CustomSnackBar.showError(context, state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return (state is AddNotesLoading)
                      ? Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CustomLoadingIndicator(),
                          ),
                        )
                      : Row(
                          children: [
                            // Cancel Button
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  side: BorderSide(color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'إلغاء',
                                  style: AppStyles.styleSemiBold16(
                                    context,
                                  ).copyWith(color: Colors.grey.shade600),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),

                            // Save Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (widget.noteController.text
                                      .trim()
                                      .isNotEmpty) {
                                    // TODO: Call the save note method from your cubit
                                    _addNote(
                                      note: CreateNotesModel(
                                        content: widget.noteController.text
                                            .trim(),
                                      ),
                                      shipmentId: widget.shipmentId,
                                    );
                                    Navigator.pop(context);

                                    // Show success message
                                    CustomSnackBar.showSuccess(
                                      context,
                                      'تم حفظ الملاحظة بنجاح',
                                    );
                                  } else {
                                    // Show error for empty note
                                    CustomSnackBar.showWarning(
                                      context,
                                      'يرجى كتابة الملاحظة أولاً',
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'حفظ',
                                  style: AppStyles.styleSemiBold16(
                                    context,
                                  ).copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
