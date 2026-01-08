/// Custom font families available in the app
enum AppFont {
  hadi('Hadi', 'হাদি'),
  hadiRounded('HadiRounded', 'হাদি বৃত্তাকার'),
  abuSayed('AbuSayed', 'আবু সাঈদ');

  final String fontFamily;
  final String displayName;

  const AppFont(this.fontFamily, this.displayName);
}
