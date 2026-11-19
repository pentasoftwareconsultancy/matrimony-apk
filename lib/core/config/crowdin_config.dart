/// Configuration for Crowdin Over-The-Air (OTA) Translation Delivery.
class CrowdinConfig {
  /// Crowdin Distribution Hash for Over-The-Air (OTA) translation delivery.
  /// 
  /// To connect to your Crowdin project:
  /// 1. Go to your Crowdin Project Settings -> Translations.
  /// 2. Under 'Over-The-Air Content Delivery', create or copy your Distribution Hash.
  /// 3. Replace 'YOUR_DISTRIBUTION_HASH' below with your actual distribution hash.
  /// 
  /// The distribution hash is a public identifier designed for client-side OTA delivery.
  /// No private API tokens or secrets are required for client OTA updates.
  static const String distributionHash = 'YOUR_DISTRIBUTION_HASH';

  /// Whether a valid distribution hash is configured.
  static bool get isConfigured =>
      distributionHash.isNotEmpty && distributionHash != 'YOUR_DISTRIBUTION_HASH';
}
