import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coffee_controller.dart';

class CartScreen extends GetView<CoffeeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Obx(() {
            if (controller.cartItems.isNotEmpty) {
              return IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.white),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Clear Cart',
                    middleText: 'Are you sure you want to clear all items?',
                    backgroundColor: Color(0xFF2A2A2A),
                    titleStyle: TextStyle(color: Colors.white),
                    middleTextStyle: TextStyle(color: Colors.white70),
                    textConfirm: 'Yes',
                    textCancel: 'No',
                    confirmTextColor: Colors.white,
                    cancelTextColor: Colors.white,
                    buttonColor: AppColors.kPrimaryColor,
                    onConfirm: () {
                      controller.clearCart();
                      Get.back();
                    },
                  );
                },
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Add some coffee to get started',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Browse Coffee',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return Dismissible(
                    key: Key('${item.name}_$index'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      controller.removeFromCart(item);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey,
                                  child: Icon(Icons.coffee, color: Colors.white),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 8),

                              // quantity control ka view yahan se shuru hota
                                Row(
                                  children: [
                                    // Decrease button
                                    InkWell(
                                      onTap: () {
                                        controller.decreaseQuantity(item);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1A1A1A),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // Quantity display
                                    Obx(() => Text(
                                      '${controller.getQuantity(item.id)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    SizedBox(width: 12),
                                    // Increase button
                                    InkWell(
                                      onTap: () {
                                        controller.increaseQuantity(item);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.kPrimaryColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Price Column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Single item price
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Total price for this item (price × quantity)
                              Obx(() {
                                final qty = controller.getQuantity(item.id);
                                final totalItemPrice = item.price * qty;
                                return Text(
                                  '\$${totalItemPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: AppColors.kPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                              SizedBox(height: 8),
                              // Delete button
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  controller.removeFromCart(item);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Total Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Items',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Obx(() => Text(
                          '${controller.cartCount.value}', // Total quantity
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Unique Items',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Obx(() => Text(
                          '${controller.uniqueItemsCount}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey[800]),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(() => Text(
                          '\$${controller.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: AppColors.kPrimaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          controller.processCheckout();
                          // controller.clearCart();                         
                          // Get.snackbar(
                          //   'Checkout',
                          //   'Total: \$${controller.totalPrice.toStringAsFixed(2)}',
                          //   snackPosition: SnackPosition.BOTTOM,
                          //   backgroundColor: AppColors.kOrangeColor,
                          //   colorText: Colors.white,
                          // );
                          // Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}