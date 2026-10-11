abstract final class MockReceipt {
  static const String merchant = 'Owl Market';
  static const String mode = 'Receipt';
  static const String priceTagMode = 'Price Tag';
  static const Map<String, double> items = {
    'Milk 2L': 560,
    'Bread': 180,
    'Eggs x12': 480,
    'Rice 5kg': 1880,
  };
  static const double total = 3100;
  static const String scannerDisclosure =
      'Offline sample scanner · no OCR is performed';
  static const String captureButtonLabel = 'Capture sample receipt';
  static const String reviewLabel = 'Sample receipt';
}
