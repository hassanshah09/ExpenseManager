import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../mock/mock_receipt.dart';
import '../widgets/owl_widgets.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});
  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  bool flash = false;
  String mode = MockReceipt.mode;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0B1425),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => setState(() => flash = !flash),
                  icon: Icon(
                    flash ? Icons.flash_on : Icons.flash_off,
                    color: OwlColors.gold,
                  ),
                ),
              ],
            ),
            const Text(
              'Scan receipt',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Text(
              MockReceipt.scannerDisclosure,
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Container(
                  width: 270,
                  height: 390,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    border: Border.all(color: OwlColors.gold, width: 2),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          MockReceipt.merchant.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const Divider(),
                        ...MockReceipt.items.entries.map(
                          (item) =>
                              Text('${item.key}  Rs. ${item.value.round()}'),
                        ),
                        const Spacer(),
                        const Divider(),
                        Text(
                          'TOTAL                Rs. ${MockReceipt.total.round()}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ToggleButtons(
              isSelected: [
                mode == MockReceipt.mode,
                mode == MockReceipt.priceTagMode,
              ],
              onPressed: (i) => setState(
                () =>
                    mode = i == 0 ? MockReceipt.mode : MockReceipt.priceTagMode,
              ),
              borderRadius: BorderRadius.circular(12),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Receipt'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Price Tag'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OwlButton(
              label: MockReceipt.captureButtonLabel,
              icon: Icons.camera_alt_outlined,
              onPressed: () => Navigator.pushNamed(context, '/review'),
            ),
          ],
        ),
      ),
    ),
  );
}
