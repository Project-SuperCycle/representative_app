import 'package:flutter/material.dart';
import 'package:supercycle/core/utils/app_colors.dart';
import 'package:supercycle/core/utils/app_styles.dart';

class DateTimePickerHelper {
  static Future<DateTime?> selectDateTime(
    BuildContext context, {
    DateTime? currentSelectedDateTime,
  }) async {
    // تحديد نطاق التواريخ المسموحة (من بعد يومين من اليوم الحالي فما فوق)
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime minDate = today.add(const Duration(days: 3));
    final DateTime maxDate = today.add(
      const Duration(days: 365),
    ); // حتى سنة من الآن

    // أولاً اختيار التاريخ
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentSelectedDateTime ?? minDate,
      firstDate: minDate,
      lastDate: maxDate,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
              secondary: AppColors.primaryColor,
              onSecondary: Colors.white,
            ),
            // تخصيص النصوص
            textTheme: TextTheme(
              headlineLarge: AppStyles.styleBold24(context),
              // النص الكبير للشهر والسنة
              headlineMedium: AppStyles.styleSemiBold22(context),
              // نص الأيام
              bodyLarge: AppStyles.styleMedium16(context),
              // نص العناوين
              titleMedium: AppStyles.styleSemiBold18(context),
              // نص الأزرار
              labelLarge: AppStyles.styleSemiBold16(context),
            ),
            // تخصيص الأزرار
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                textStyle: AppStyles.styleBold16(context),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                textStyle: AppStyles.styleSemiBold18(context),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // إذا تم اختيار تاريخ، اعرض اختيار الوقت
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: currentSelectedDateTime != null
            ? TimeOfDay.fromDateTime(currentSelectedDateTime)
            : TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
                secondary: AppColors.primaryColor,
                onSecondary: Colors.white,
              ),
              // تخصيص النصوص للوقت
              textTheme: TextTheme(
                // النص الكبير للوقت
                displayLarge: AppStyles.styleBold24(context),
                // نص العناوين
                titleMedium: AppStyles.styleSemiBold18(context),
                // نص الأزرار الصغيرة
                bodyMedium: AppStyles.styleMedium14(context),
                // نص الأزرار
                labelLarge: AppStyles.styleSemiBold16(context),
              ),
              // تخصيص الأزرار للوقت
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: AppStyles.styleBold16(context),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  textStyle: AppStyles.styleBold16(context),
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        // دمج التاريخ والوقت مع تحديد المنطقة الزمنية GMT+2
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // تحويل التاريخ والوقت إلى منطقة زمنية محددة (GMT+2)
        const Duration timeZoneOffset = Duration(hours: 2);
        final DateTime dateTimeWithTimeZone = DateTime.utc(
          combinedDateTime.year,
          combinedDateTime.month,
          combinedDateTime.day,
          combinedDateTime.hour,
          combinedDateTime.minute,
        ).add(timeZoneOffset);

        // طباعة التاريخ بالصيغة المطلوبة للتحقق
        formatDateTimeWithTimeZone(dateTimeWithTimeZone, timeZoneOffset);
        return dateTimeWithTimeZone;
      }
    }

    return null;
  }

  // دالة مساعدة لتنسيق التاريخ والوقت بصيغة ISO 8601 مع الـ timezone
  static String formatDateTimeWithTimeZone(DateTime dateTime, Duration offset) {
    // تحويل الـ offset إلى صيغة نصية (+02:00)
    final int offsetHours = offset.inHours;
    final int offsetMinutes = offset.inMinutes % 60;
    final String offsetString = offsetHours >= 0
        ? '+${offsetHours.toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}'
        : '-${(-offsetHours).toString().padLeft(2, '0')}:${(-offsetMinutes).toString().padLeft(2, '0')}';

    // تنسيق التاريخ والوقت
    final String formattedDateTime =
        '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}T'
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}'
        '$offsetString';

    return formattedDateTime;
  }
}
