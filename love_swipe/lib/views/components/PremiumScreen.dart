import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  String _selectedSubscription = 'Aylık'; // Default selection

  static const Set<String> _kProductIds = {'aylik2', 'yillik'};

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("Error: $error");
    });
    _initStoreInfo();
  }

  Future<void> _initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
    await _inAppPurchase.queryProductDetails(_kProductIds);
    if (productDetailResponse.error != null) {
      print("Error querying product details: ${productDetailResponse.error}");
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _isAvailable = false;
      });
      return;
    }

    setState(() {
      _isAvailable = true;
      _products = productDetailResponse.productDetails;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _deliverProduct(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _showPendingUI() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Pending...")));
  }

  void _handleError(IAPError error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: ${error.message}")));
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Purchased successfully!")));
  }

  void _buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
    PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Premium'),
        ),
        body: const Center(
          child: Text('Store is not available.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'VIP statüsü',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/pay/ofof.png',
                width: 190,
                height: 190,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeature(Icons.block, 'Reklamsız insanlarla tanış'),
                  _buildFeature(Icons.message, 'Sınırsız mesaj hakkı'),
                  _buildFeature(Icons.video_call, 'Görüntülü görüşme'),
                  _buildFeature(Icons.photo, 'Sınırsız hikaye paylaşma'),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption('Aylık', '₺99,99',
                      _selectedSubscription == 'Aylık'),
                  _buildOption('Yıllık', '₺49,99/ay',
                      _selectedSubscription == 'Yıllık'),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_selectedSubscription == 'Aylık' &&
                      _products.isNotEmpty) {
                    _buyProduct(_products[0]);
                  } else if (_selectedSubscription == 'Yıllık' &&
                      _products.isNotEmpty) {
                    _buyProduct(_products[1]);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Abone Ol',
                    style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Hizmet abonelik ile sağlanmaktadır. Abonelik sırasında ödeme Google Play hesabınızdan yapılacaktır. '
                      'Otomatik yenileme, aboneliğin bitiminden 24 saat önce gerçekleşecektir. Hizmet, Google Play Hesap Ayarlarından iptal edilene kadar otomatik olarak yenilenecektir. '
                      'Daha fazla bilgi Kullanıcı Anlaşması ve Hizmet koşulları bölümlerinde mevcuttur.',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String duration, String price, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubscription = duration;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.orange.shade100 : Colors.white,
          border: isSelected ? Border.all(color: Colors.orange) : Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text(duration, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
