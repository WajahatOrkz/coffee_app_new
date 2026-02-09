import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/auth/presentation/controllers/logout_controller.dart';
import 'package:coffee_app/features/auth/presentation/widgets/custom_loader.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/coffee_controller.dart';
import 'package:coffee_app/features/coffee/presentation/widgets/coffee_card.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/coffee_card_shimmer.dart';

class CoffeeHomeView extends GetView<CoffeeController> {
  @override
  Widget build(BuildContext context) {
    LogoutController logoutController = Get.find<LogoutController>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          title: Text(
            "Coffee App",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          centerTitle: false,
          actions: [
            Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
            SizedBox(width: 16),

            // Cart Icon with Badge
            Obx(() {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      // Navigate to Cart Screen
                      Get.toNamed(AppRoutes.kCartRoute);
                    },
                  ),
                  if (controller.cartCount.value > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to Cart Screen
                          Get.toNamed(AppRoutes.kCartRoute);
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                          child: Center(
                            child: Text(
                              '${controller.cartCount.value}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
            SizedBox(width: 10),

            IconButton(
              onPressed: () async {
                print("logout button is pressing");
                await logoutController.logout();
              },
              icon: Icon(Icons.logout, color: Colors.white, size: 20),
            ),

            SizedBox(width: 10),
          ],
        ),
        body: Obx(
          () => Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Order Delicious Meal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search Coffee',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus!
                                .unfocus(); //ye jab user textfield main icon pe click kren or icon pe click krne k bd bottom sheet khulti jab us main bagher kuch behave kiye wapis aye to keyboard khula nahi rehta
                            Get.bottomSheet(
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black87,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      "Bottom Sheet Opened",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            controller.decrementFilter();
                                          },
                                          icon: Icon(Icons.remove),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            iconSize: 15,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Obx(
                                          () => Text(
                                            "\$${controller.filteredPrice.value}",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        IconButton(
                                          onPressed: () {
                                            controller.incrementFilter();
                                          },
                                          icon: Icon(Icons.add),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            iconSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),

                                    TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.applyFilters();

                                        Get.back();
                                        // Future.delayed(Duration(microseconds: 100));
                                        FocusManager.instance.primaryFocus!
                                            .unfocus(); //bottomsheet bnd hone k bd keyboard disappear yahan se hota
                                      },

                                      child: Text("Filtered Data"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Icon(Icons.tune, color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Color(0xFF2A2A2A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (value) {
                        controller.searchCoffee(value);
                      },
                      onChanged: (value) {
                        print('TextField value: $value');
                        controller.searchCoffee(value);
                      },
                    ),
                  ),

                  SizedBox(height: 24),

                  // Categories Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                 

                  SizedBox(height: 24),

                  // Coffee Grid
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: controller.isLoading.value ? 4 : controller.searchedCoffeeList.length,
                      itemBuilder: (context, index) {
                        if (controller.isLoading.value) {
                          return CoffeeCardShimmer();
                        }
                        final coffeeItem = controller.searchedCoffeeList[index];
                        return CoffeeCard(coffeeData: coffeeItem);
                      },
                    ),
                  ),
                ],
              ),
              controller.isLoading.value? CustomLoader(): SizedBox.shrink(),
              if (logoutController.isLoading.value) CustomLoader(),
            ],
          ),
        ),
      ),
    );
  }
}
