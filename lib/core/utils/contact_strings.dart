class ContactStrings {
  static const Map<String, Map<String, String>> _strings = {
    'ar': {
      'title': 'للتواصل معنا',
      'switchToEnglish': 'Switch to English',
      'headerTitle': 'نحن هنا للمساعدة',
      'headerSubtitle': 'املأ النموذج أدناه وسنتواصل معك قريباً',
      'fullName': 'الاسم الكامل',
      'fullNameHint': 'أدخل اسمك الكامل',
      'email': 'البريد الإلكتروني',
      'emailHint': 'أدخل بريدك الإلكتروني',
      'mobile': 'رقم الهاتف',
      'mobileHint': 'أدخل رقم هاتفك',
      'messageTopic': 'سبب رسالتك',
      'Select a topic' :'اختر موضوع الرسالة'  ,
      'message': 'رسالتك',
      'messageHint': 'اكتب رسالتك هنا...',
      'merchantQuestion': 'هل أنت تاجر ورق دشت؟',
      'yes': 'نعم',
      'no': 'لا',
      'sendMessage': 'إرسال الرسالة',
      'successTitle': 'تم الإرسال بنجاح',
      'successMessage': 'شكراً لك! تم إرسال رسالتك بنجاح وسنقوم بالرد عليك قريباً.',
      'ok': 'حسناً',
      'requiredField': 'هذا الحقل مطلوب',
      'invalidEmail': 'البريد الإلكتروني غير صالح',
      'mobileTooShort': 'رقم الهاتف قصير جداً',
      'selectMerchantAnswer': 'يرجى اختيار إجابة لسؤال تاجر ورق الخيش',
      'agentInfo': 'وكيل / +91-99620xxxxx',
      'submissionFailed': 'فشل في الإرسال. يرجى المحاولة مرة أخرى.',
      'errorOccurred': 'حدث خطأ. يرجى المحاولة مرة أخرى.',
    },
    'en': {
      'title': 'Contact Us',
      'switchToEnglish': 'التبديل للعربية',
      'headerTitle': 'We\'re Here to Help',
      'headerSubtitle': 'Fill out the form below and we\'ll get back to you soon',
      'fullName': 'Full Name',
      'fullNameHint': 'Enter your full name',
      'email': 'Email Address',
      'emailHint': 'Enter your email address',
      'mobile': 'Mobile Number',
      'mobileHint': 'Enter your mobile number',
      'message': 'Your Message',
      'messageHint': 'Write your message here...',
      'merchantQuestion': 'Are You A Rag Paper Merchant?',
      'yes': 'Yes',
      'no': 'No',
      'sendMessage': 'Send Message',
      'successTitle': 'Successfully Sent',
      'successMessage': 'Thank you! Your message has been sent successfully and we will get back to you soon.',
      'ok': 'OK',
      'requiredField': 'This field is required',
      'invalidEmail': 'Invalid email address',
      'mobileTooShort': 'Mobile number is too short',
      'selectMerchantAnswer': 'Please select an answer for the rag paper merchant question',
      'agentInfo': 'Agent / +91-99620xxxxx',
      'submissionFailed': 'Submission failed. Please try again.',
      'errorOccurred': 'An error occurred. Please try again.',
    },
  };

  static String get(String key, bool isArabic) {
    final lang = isArabic ? 'ar' : 'en';
    return _strings[lang]?[key] ?? key;
  }

  static Map<String, String> getAll(bool isArabic) {
    final lang = isArabic ? 'ar' : 'en';
    return _strings[lang] ?? {};
  }

  static bool hasKey(String key) {
    return _strings['en']?.containsKey(key) ?? false;
  }
}