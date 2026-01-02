// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `supercycle`
  String get title {
    return Intl.message('supercycle', name: 'title', desc: '', args: []);
  }

  /// `Language`
  String get lang {
    return Intl.message('Language', name: 'lang', desc: '', args: []);
  }

  /// `Do you want to buy?`
  String get buy_title {
    return Intl.message(
      'Do you want to buy?',
      name: 'buy_title',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to sell?`
  String get sell_title {
    return Intl.message(
      'Do you want to sell?',
      name: 'sell_title',
      desc: '',
      args: [],
    );
  }

  /// `Start your journey with us`
  String get signUp_title {
    return Intl.message(
      'Start your journey with us',
      name: 'signUp_title',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account`
  String get signUp_subTitle {
    return Intl.message(
      'Create a new account',
      name: 'signUp_subTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp_button {
    return Intl.message('Sign Up', name: 'signUp_button', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// ` Email`
  String get email_phone {
    return Intl.message(' Email', name: 'email_phone', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Or register via`
  String get or_register_via {
    return Intl.message(
      'Or register via',
      name: 'or_register_via',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account`
  String get already_have_an_account {
    return Intl.message(
      'Already have an account',
      name: 'already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Entity information`
  String get entity_information {
    return Intl.message(
      'Entity information',
      name: 'entity_information',
      desc: '',
      args: [],
    );
  }

  /// `Entity name`
  String get entity_name {
    return Intl.message('Entity name', name: 'entity_name', desc: '', args: []);
  }

  /// `Type of business`
  String get entity_type {
    return Intl.message(
      'Type of business',
      name: 'entity_type',
      desc: '',
      args: [],
    );
  }

  /// `Entity address`
  String get entity_address {
    return Intl.message(
      'Entity address',
      name: 'entity_address',
      desc: '',
      args: [],
    );
  }

  /// `Entity email`
  String get entity_email {
    return Intl.message(
      'Entity email',
      name: 'entity_email',
      desc: '',
      args: [],
    );
  }

  /// `Administrator Name`
  String get administrator_name {
    return Intl.message(
      'Administrator Name',
      name: 'administrator_name',
      desc: '',
      args: [],
    );
  }

  /// `Administrator Phone`
  String get administrator_phone {
    return Intl.message(
      'Administrator Phone',
      name: 'administrator_phone',
      desc: '',
      args: [],
    );
  }

  /// `Administrator Email`
  String get administrator_email {
    return Intl.message(
      'Administrator Email',
      name: 'administrator_email',
      desc: '',
      args: [],
    );
  }

  /// `We are happy to have you with us`
  String get signIn_title {
    return Intl.message(
      'We are happy to have you with us',
      name: 'signIn_title',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to your account`
  String get signIn_subTitle {
    return Intl.message(
      'Sign in to your account',
      name: 'signIn_subTitle',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgot_password {
    return Intl.message(
      'Forgot Password',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get create_account {
    return Intl.message(
      'Create New Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get signIn_button {
    return Intl.message('Login', name: 'signIn_button', desc: '', args: []);
  }

  /// `Verify your account`
  String get otp_verify_title {
    return Intl.message(
      'Verify your account',
      name: 'otp_verify_title',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the OTP code that was sent to`
  String get otp_verify_subTitle {
    return Intl.message(
      'Please enter the OTP code that was sent to',
      name: 'otp_verify_subTitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get otp_verify_button {
    return Intl.message(
      'Verify',
      name: 'otp_verify_button',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `What are you looking for...`
  String get search {
    return Intl.message(
      'What are you looking for...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Price Indicator`
  String get price_indicator {
    return Intl.message(
      'Price Indicator',
      name: 'price_indicator',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message('Monthly', name: 'monthly', desc: '', args: []);
  }

  /// `Paper Type`
  String get paper_type {
    return Intl.message('Paper Type', name: 'paper_type', desc: '', args: []);
  }

  /// `Types`
  String get types {
    return Intl.message('Types', name: 'types', desc: '', args: []);
  }

  /// `Calculator`
  String get calculation {
    return Intl.message('Calculator', name: 'calculation', desc: '', args: []);
  }

  /// `Make Process`
  String get make_process {
    return Intl.message(
      'Make Process',
      name: 'make_process',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contact_us {
    return Intl.message('Contact us', name: 'contact_us', desc: '', args: []);
  }

  /// `Shipment Schedule`
  String get shipment_schedule {
    return Intl.message(
      'Shipment Schedule',
      name: 'shipment_schedule',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Carton`
  String get carton {
    return Intl.message('Carton', name: 'carton', desc: '', args: []);
  }

  /// `Paper`
  String get paper {
    return Intl.message('Paper', name: 'paper', desc: '', args: []);
  }

  /// `Sale Process`
  String get sale_process {
    return Intl.message(
      'Sale Process',
      name: 'sale_process',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a photo of the shipment if available`
  String get upload_shipment_photo_hint {
    return Intl.message(
      'Please upload a photo of the shipment if available',
      name: 'upload_shipment_photo_hint',
      desc: '',
      args: [],
    );
  }

  /// `Entity data`
  String get entity_data {
    return Intl.message('Entity data', name: 'entity_data', desc: '', args: []);
  }

  /// `Shipment details`
  String get trader_shipment_details {
    return Intl.message(
      'Shipment details',
      name: 'trader_shipment_details',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Shipment number`
  String get shipment_number {
    return Intl.message(
      'Shipment number',
      name: 'shipment_number',
      desc: '',
      args: [],
    );
  }

  /// `Shipment date`
  String get shipment_date {
    return Intl.message(
      'Shipment date',
      name: 'shipment_date',
      desc: '',
      args: [],
    );
  }

  /// `Shipment status`
  String get shipment_status {
    return Intl.message(
      'Shipment status',
      name: 'shipment_status',
      desc: '',
      args: [],
    );
  }

  /// `Date of receipt`
  String get date_of_receipt {
    return Intl.message(
      'Date of receipt',
      name: 'date_of_receipt',
      desc: '',
      args: [],
    );
  }

  /// `Registration date`
  String get registration_date {
    return Intl.message(
      'Registration date',
      name: 'registration_date',
      desc: '',
      args: [],
    );
  }

  /// `Representative`
  String get representative {
    return Intl.message(
      'Representative',
      name: 'representative',
      desc: '',
      args: [],
    );
  }

  /// `Date of last modification`
  String get date_of_last_modification {
    return Intl.message(
      'Date of last modification',
      name: 'date_of_last_modification',
      desc: '',
      args: [],
    );
  }

  /// `Transportation data`
  String get transportation_data {
    return Intl.message(
      'Transportation data',
      name: 'transportation_data',
      desc: '',
      args: [],
    );
  }

  /// `Truck`
  String get truck {
    return Intl.message('Truck', name: 'truck', desc: '', args: []);
  }

  /// `Driver's name`
  String get driver_name {
    return Intl.message(
      'Driver\'s name',
      name: 'driver_name',
      desc: '',
      args: [],
    );
  }

  /// `Driver's Phone`
  String get driver_phone {
    return Intl.message(
      'Driver\'s Phone',
      name: 'driver_phone',
      desc: '',
      args: [],
    );
  }

  /// `Shipment follow-up schedule`
  String get Shipment_follow_up_schedule {
    return Intl.message(
      'Shipment follow-up schedule',
      name: 'Shipment_follow_up_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Follow up on shipment delivery dates and delivery procedures`
  String get Shipment_follow_up_schedule_hint {
    return Intl.message(
      'Follow up on shipment delivery dates and delivery procedures',
      name: 'Shipment_follow_up_schedule_hint',
      desc: '',
      args: [],
    );
  }

  /// `It will be delivered during the month`
  String get pending_shipment_hint {
    return Intl.message(
      'It will be delivered during the month',
      name: 'pending_shipment_hint',
      desc: '',
      args: [],
    );
  }

  /// `It is Delivered within the month`
  String get delivered_shipment_hint {
    return Intl.message(
      'It is Delivered within the month',
      name: 'delivered_shipment_hint',
      desc: '',
      args: [],
    );
  }

  /// `Delivered shipments`
  String get delivered_shipments {
    return Intl.message(
      'Delivered shipments',
      name: 'delivered_shipments',
      desc: '',
      args: [],
    );
  }

  /// `Shipments to be delivered`
  String get pending_shipments {
    return Intl.message(
      'Shipments to be delivered',
      name: 'pending_shipments',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `close`
  String get close {
    return Intl.message('close', name: 'close', desc: '', args: []);
  }

  /// `delete`
  String get delete {
    return Intl.message('delete', name: 'delete', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Add Notes`
  String get add_notes_title {
    return Intl.message(
      'Add Notes',
      name: 'add_notes_title',
      desc: '',
      args: [],
    );
  }

  /// `You can leave your notes here and they will be reviewed by the administration`
  String get add_notes_hint {
    return Intl.message(
      'You can leave your notes here and they will be reviewed by the administration',
      name: 'add_notes_hint',
      desc: '',
      args: [],
    );
  }

  /// `Previous transactions`
  String get previous_transactions_title {
    return Intl.message(
      'Previous transactions',
      name: 'previous_transactions_title',
      desc: '',
      args: [],
    );
  }

  /// `Show details`
  String get show_details {
    return Intl.message(
      'Show details',
      name: 'show_details',
      desc: '',
      args: [],
    );
  }

  /// `Select type`
  String get select_type {
    return Intl.message('Select type', name: 'select_type', desc: '', args: []);
  }

  /// `EGP`
  String get money {
    return Intl.message('EGP', name: 'money', desc: '', args: []);
  }

  /// `Kg`
  String get unit {
    return Intl.message('Kg', name: 'unit', desc: '', args: []);
  }

  /// `This field is required`
  String get field_required {
    return Intl.message(
      'This field is required',
      name: 'field_required',
      desc: '',
      args: [],
    );
  }

  /// `invalid email`
  String get invalid_email {
    return Intl.message(
      'invalid email',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `invalid phone`
  String get invalid_phone {
    return Intl.message(
      'invalid phone',
      name: 'invalid_phone',
      desc: '',
      args: [],
    );
  }

  /// `invalid email or phone`
  String get invalid_email_or_phone {
    return Intl.message(
      'invalid email or phone',
      name: 'invalid_email_or_phone',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get password_required {
    return Intl.message(
      'Password is required',
      name: 'password_required',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters long`
  String get password_length_error {
    return Intl.message(
      'Password must be at least 8 characters long',
      name: 'password_length_error',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one uppercase letter`
  String get password_uppercase_error {
    return Intl.message(
      'Password must contain at least one uppercase letter',
      name: 'password_uppercase_error',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one lowercase letter`
  String get password_lowercase_error {
    return Intl.message(
      'Password must contain at least one lowercase letter',
      name: 'password_lowercase_error',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one number`
  String get password_number_error {
    return Intl.message(
      'Password must contain at least one number',
      name: 'password_number_error',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one special character`
  String get password_specialChar_error {
    return Intl.message(
      'Password must contain at least one special character',
      name: 'password_specialChar_error',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `supercycle Number One`
  String get onboarding_1 {
    return Intl.message(
      'supercycle Number One',
      name: 'onboarding_1',
      desc: '',
      args: [],
    );
  }

  /// `supercycle Number One`
  String get onboarding_2 {
    return Intl.message(
      'supercycle Number One',
      name: 'onboarding_2',
      desc: '',
      args: [],
    );
  }

  /// `supercycle Number One`
  String get onboarding_3 {
    return Intl.message(
      'supercycle Number One',
      name: 'onboarding_3',
      desc: '',
      args: [],
    );
  }

  /// `You must agree to the privacy policy`
  String get privacy_policy_required {
    return Intl.message(
      'You must agree to the privacy policy',
      name: 'privacy_policy_required',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to supercycle`
  String get sign_in_alert_title {
    return Intl.message(
      'Welcome to supercycle',
      name: 'sign_in_alert_title',
      desc: '',
      args: [],
    );
  }

  /// `You are not logined, please login to continue`
  String get sign_in_alert_message {
    return Intl.message(
      'You are not logined, please login to continue',
      name: 'sign_in_alert_message',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get alert_ok_button {
    return Intl.message('OK', name: 'alert_ok_button', desc: '', args: []);
  }

  /// `Cancel`
  String get alert_cancel_button {
    return Intl.message(
      'Cancel',
      name: 'alert_cancel_button',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get drawer_home {
    return Intl.message('Home', name: 'drawer_home', desc: '', args: []);
  }

  /// `Profile`
  String get drawer_profile {
    return Intl.message('Profile', name: 'drawer_profile', desc: '', args: []);
  }

  /// `Settings`
  String get drawer_settings {
    return Intl.message(
      'Settings',
      name: 'drawer_settings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get drawer_logout {
    return Intl.message('Logout', name: 'drawer_logout', desc: '', args: []);
  }

  /// `Sign In`
  String get drawer_sign_in {
    return Intl.message('Sign In', name: 'drawer_sign_in', desc: '', args: []);
  }

  /// `Contact Us`
  String get drawer_contact_us {
    return Intl.message(
      'Contact Us',
      name: 'drawer_contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get drawer_language {
    return Intl.message(
      'Language',
      name: 'drawer_language',
      desc: '',
      args: [],
    );
  }

  /// `Sales Calendar`
  String get drawer_sales_calender {
    return Intl.message(
      'Sales Calendar',
      name: 'drawer_sales_calender',
      desc: '',
      args: [],
    );
  }

  /// `Transactions Table`
  String get drawer_transactions_table {
    return Intl.message(
      'Transactions Table',
      name: 'drawer_transactions_table',
      desc: '',
      args: [],
    );
  }

  /// `Environmental Impact`
  String get drawer_environmental_impact {
    return Intl.message(
      'Environmental Impact',
      name: 'drawer_environmental_impact',
      desc: '',
      args: [],
    );
  }

  /// `Start date of cooperation`
  String get start_date {
    return Intl.message(
      'Start date of cooperation',
      name: 'start_date',
      desc: '',
      args: [],
    );
  }

  /// `Preferred payment method`
  String get payment_method {
    return Intl.message(
      'Preferred payment method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Shipment Review`
  String get shipment_review {
    return Intl.message(
      'Shipment Review',
      name: 'shipment_review',
      desc: '',
      args: [],
    );
  }

  /// `Edit Shipment`
  String get shipment_edit {
    return Intl.message(
      'Edit Shipment',
      name: 'shipment_edit',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Process`
  String get confirm_process {
    return Intl.message(
      'Confirm Process',
      name: 'confirm_process',
      desc: '',
      args: [],
    );
  }

  /// `Table of Shipments`
  String get table_of_shipments {
    return Intl.message(
      'Table of Shipments',
      name: 'table_of_shipments',
      desc: '',
      args: [],
    );
  }

  /// `Follow up on shipment delivery dates and delivery procedures`
  String get follow_up_shipments {
    return Intl.message(
      'Follow up on shipment delivery dates and delivery procedures',
      name: 'follow_up_shipments',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
