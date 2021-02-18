class Settings {
  final int id;
  final int privacyPolicyEnabled;
  final int termsAndConditionsEnabled;
  final int aboutUsEnabled;
  final String privacyPolicy;
  final String termsAndConditions;
  final String aboutUs;
  final num serviceFee;
  final num mosqueDeliveryFee;
  final num consolationDeliveryFee;
  final num cemetryDeliveryFee;

  Settings({
    this.privacyPolicyEnabled,
    this.termsAndConditionsEnabled,
    this.aboutUsEnabled,
    this.id,
    this.privacyPolicy,
    this.termsAndConditions,
    this.aboutUs,
    this.serviceFee,
    this.mosqueDeliveryFee,
    this.consolationDeliveryFee,
    this.cemetryDeliveryFee,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'],
      privacyPolicy: json['appPrivacyPolicy'],
      termsAndConditions: json['appTermsAndConditions'],
      aboutUs: json['appAboutUs'],
      serviceFee: json['serviceFee'],
      mosqueDeliveryFee: json['mosqueDeliveryFee'],
      consolationDeliveryFee: json['consolationDeliveryFee'],
      cemetryDeliveryFee: json['cemetryDeliveryFee'],
      privacyPolicyEnabled: json['privacyPolicyEnabled'],
      termsAndConditionsEnabled: json['termsAndConditionsEnabled'],
      aboutUsEnabled: json['aboutUsEnabled'],
    );
  }
}
