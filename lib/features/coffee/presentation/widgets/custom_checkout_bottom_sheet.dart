// import 'package:coffee_app/core/constants/app_colors.dart';
// import 'package:coffee_app/features/coffee/presentation/controllers/coffee_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CheckoutBottomSheet extends StatelessWidget {
//   final controller = Get.find<CoffeeController>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Handle bar
//             Container(
//               width: 40,
//               height: 4,
//               margin: EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[700],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),

//             Text(
//               'Order Summary',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
            
//             SizedBox(height: 24),

//             // Total Items
//             _buildInfoCard(
//               icon: Icons.shopping_cart,
//               label: 'Total Items',
//               value: '${controller.cartCount.value}',
//               color: AppColors.kPrimaryColor,
//             ),
            
//             SizedBox(height: 12),

//             // Unique Items
//             _buildInfoCard(
//               icon: Icons.coffee,
//               label: 'Unique Items',
//               value: '${controller.uniqueItemsCount}',
//               color: Colors.orange,
//             ),
            
//             SizedBox(height: 16),
//             Divider(color: Colors.grey[800], thickness: 1),
//             SizedBox(height: 16),

//             // Total Price
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.kPrimaryColor.withOpacity(0.2),
//                     AppColors.kPrimaryColor.withOpacity(0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: AppColors.kPrimaryColor.withOpacity(0.3),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.attach_money,
//                         color: AppColors.kPrimaryColor,
//                         size: 28,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         'Total Price',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     '\$${controller.totalPrice.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: AppColors.kPrimaryColor,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 24),

//             // Confirm Button
//             Obx(() => SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: controller.isLoading.value
//                     ? null
//                     : () async {
//                         await controller.confirmOrder();
                        
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kPrimaryColor,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: controller.isLoading.value
//                     ? SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Text(
//                         'Confirm Order',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//               ),
//             )),

//             SizedBox(height: 12),

//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () => Get.back(),
//                 child: Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.grey, fontSize: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFF2A2A2A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[800]!),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: color, size: 24),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(color: Colors.grey, fontSize: 14),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/coffee_controller.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final controller = Get.find<CoffeeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                'Order Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 24),

              // Total Items
              _buildInfoCard(
                icon: Icons.shopping_cart,
                label: 'Total Items',
                value: '${controller.cartCount.value}',
                color: AppColors.kPrimaryColor,
              ),
              
              SizedBox(height: 12),

              // Unique Items
              _buildInfoCard(
                icon: Icons.coffee,
                label: 'Unique Items',
                value: '${controller.uniqueItemsCount}',
                color: Colors.orange,
              ),
              
              SizedBox(height: 20),
              
              Divider(color: Colors.grey[800], thickness: 1),
              
              SizedBox(height: 20),

              // Store Location Section
              if (Get.isRegistered<StoreController>())
                Obx(() {
                  final store = Get.find<StoreController>().selectedStore.value;
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Store Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[800]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.kPrimaryColor),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store?.name ?? 'No Store Selected',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (store != null)
                                    Text(
                                      store.address,
                                      style: TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.grey[800], thickness: 1),
                      SizedBox(height: 20),
                    ],
                  );
                }),

              // Payment Method Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Payment Method',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              SizedBox(height: 12),

              // Cash Payment Option
              Obx(() => _buildPaymentOption(
                icon: Icons.money,
                title: 'Cash Payment',
                subtitle: 'Tax: 10%',
                value: 'cash',
                isSelected: controller.selectedPaymentMethod.value == 'cash',
              )),
              
              SizedBox(height: 12),

              // Card Payment Option
              Obx(() => _buildPaymentOption(
                icon: Icons.credit_card,
                title: 'Card Payment',
                subtitle: 'Tax: 5%',
                value: 'card',
                isSelected: controller.selectedPaymentMethod.value == 'card',
              )),
              
              SizedBox(height: 20),
              
              Divider(color: Colors.grey[800], thickness: 1),
              
              SizedBox(height: 20),

              // Price Breakdown
              Obx(() {
                if (controller.selectedPaymentMethod.value.isNotEmpty) {
                  return Column(
                    children: [
                      // Subtotal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${controller.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8),

                      // Tax
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax (${controller.taxPercentage})',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '+\$${controller.taxAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      Divider(color: Colors.grey[800], thickness: 1),
                      
                      SizedBox(height: 16),
                    ],
                  );
                }
                return SizedBox.shrink();
              }),

              // Final Total Price
              Obx(() => Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kPrimaryColor.withValues(alpha: 0.2),
                      AppColors.kPrimaryColor.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.kPrimaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: AppColors.kPrimaryColor,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          controller.selectedPaymentMethod.value.isEmpty 
                              ? 'Total' 
                              : 'Final Total',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${controller.finalTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.kPrimaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),

              SizedBox(height: 24),

              // Confirm Button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (controller.isLoading.value || 
                              controller.selectedPaymentMethod.value.isEmpty)
                      ? null
                      : () async {
                          await controller.confirmOrder();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.selectedPaymentMethod.value.isEmpty 
                        ? Colors.grey 
                        : AppColors.kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          controller.selectedPaymentMethod.value.isEmpty 
                              ? 'Select Payment Method' 
                              : 'Confirm Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              )),

              SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        controller.setPaymentMethod(value);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.kPrimaryColor.withValues(alpha: 0.2) 
              : Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.kPrimaryColor : Colors.grey[800]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.kPrimaryColor.withValues(alpha: 0.2) 
                    : Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.kPrimaryColor : Colors.white70,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.kPrimaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.kPrimaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}