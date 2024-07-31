import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../constants/app_colors.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<dynamic> _streamSubscription;
List<ProductDetails> _products = [];
const _variant = {"love-swipe just once", "love-swipe yearly"};

class _PremiumScreenState extends State<PremiumScreen> {
  final String mainImageUrl = 'assets/pay/background_pay.png';

  final String image1Url = 'assets/pay/tac_pay.png';

  final String image2Url = 'assets/pay/love_swap_pay.png';

  final String image3Url = 'assets/pay/premium_pay.png';

  final String image4Url = 'assets/pay/text_pay.png';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseList) {
      _listenToPurchase(purchaseList, context);
    }, onDone: () {
      _streamSubscription.cancel();
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error")));
    });
    initStore();
  }

  initStore() async {
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(_variant);
    print("productDetailsResponse.error");
    print(productDetailsResponse.error);
    if (productDetailsResponse.error == null) {
      setState(() {
        _products = productDetailsResponse.productDetails;
        print("_products set state");
        print(_products);
      });
    }
  }

  _listenToPurchase(
      List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Pending")));
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Purchased")));
      }
    });
  }

  _buy(int which) {
    print("_products");
    print(_products);
    final PurchaseParam param = PurchaseParam(productDetails: _products[which]);
    _inAppPurchase.buyConsumable(purchaseParam: param);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              mainImageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Premium Satın Alın",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Image.asset(
                      image1Url,
                      width: MediaQuery.sizeOf(context).width * .9,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      image2Url,
                      width: MediaQuery.sizeOf(context).width * .7,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      image3Url,
                      width: MediaQuery.sizeOf(context).width * .7,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      image4Url,
                      width: MediaQuery.sizeOf(context).width * .7,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 40,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey, width: .5)),
                            child: Column(
                              children: [
                                const Text(
                                  'Aylık\n99.99₺',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _buy(0);
                                    print("99.99tl ödeme");
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                  ),
                                  child: const Text(
                                    'Satın Alın',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 40,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ],
                                border: Border.all(
                                    color: Colors.grey, width: .5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Yıllık\n49.99₺/ay',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _buy(1);
                                    print("49.99tl/ay ödeme");
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                  ),
                                  child: const Text(
                                    'Satın Alın',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
