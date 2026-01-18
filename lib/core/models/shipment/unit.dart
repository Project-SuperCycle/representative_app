enum Unit {
  kg('كيلو جرام', 'كجم'),
  ton('طن', 'طن');

  const Unit(this.displayName, this.abbreviation);

  final String displayName;
  final String abbreviation;
}
