import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),

        title: const Text(
          "Payment Methods",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            14,
            18,
            24,
          ),
          child: Column(
            children: [

              //==========================
              // SAVED CARDS
              //==========================

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(
                      0xffD8E0F0,
                    ),
                  ),
                ),
                child: Column(
                  children: [

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(
                              0xffE6EBF5,
                            ),
                          ),
                        ),
                      ),
                      child: const Text(
                        "SAVED CARDS",
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: .8,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    _savedCard(
                      number: "**** 1234",
                      expire: "Expires 12/25",
                    ),

                    const Divider(
                      height: 1,
                      color: Color(
                        0xffE6EBF5,
                      ),
                    ),

                    _savedCard(
                      number: "**** 5678",
                      expire: "Expires 08/26",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              //==========================
              // DIGITAL WALLET
              //==========================

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(
                      0xffD8E0F0,
                    ),
                  ),
                ),
                child: Column(
                  children: [

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(
                              0xffE6EBF5,
                            ),
                          ),
                        ),
                      ),
                      child: const Text(
                        "DIGITAL WALLETS",
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: .8,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    _walletItem(
                      walletName: "GoPay",
                      balance: "Balance: \$45.00",
                      iconColor: Color(0xff1BC7C6),
                    ),

                    const Divider(
                      height: 1,
                      color: Color(
                        0xffE6EBF5,
                      ),
                    ),

                    _walletItem(
                      walletName: "OVO",
                      balance: "Balance: \$12.50",
                      iconColor: Color(0xff7B5CE6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () {},

                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),

                  icon: const Icon(
                    Icons.add,
                  ),

                  label: const Text(
                    "Add New Payment Method",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
                          ],
          ),
        ),
      ),
    );
  }

  //==================================================
  // SAVED CARD ITEM
  //==================================================

  Widget _savedCard({
    required String number,
    required String expire,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xffF4F6FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.credit_card,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  expire,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Color(0xffC9CED8),
            size: 22,
          ),
        ],
      ),
    );
  }

  //==================================================
  // DIGITAL WALLET ITEM
  //==================================================

  Widget _walletItem({
    required String walletName,
    required String balance,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  walletName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  balance,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              const Text(
                "Top Up",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1.8,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}