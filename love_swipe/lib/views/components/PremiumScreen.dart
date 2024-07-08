import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  final String mainImageUrl = 'assets/pay/background_pay.png';
  final String image1Url = 'assets/pay/tac_pay.png';
  final String image2Url = 'assets/pay/love_swap_pay.png';
  final String image3Url = 'assets/pay/premium_pay.png';
  final String image4Url = 'assets/pay/text_pay.png';

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
                icon: Icon(Icons.arrow_back,color: Colors.white,),
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
                          InkWell(
                            onTap: () {
                              print("99.99tl ödeme");
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Aylık\n99.99₺',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
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
                          ),
                          InkWell(
                            onTap: () {
                              print("49.99tl/ay ödeme");
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Yıllık\n49.99₺/ay',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
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
