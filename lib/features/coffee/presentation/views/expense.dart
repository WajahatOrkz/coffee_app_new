// lib/features/coffee/presentation/views/expense_view.dart

import 'package:coffee_app/core/theme/app_colors.dart';
import 'package:coffee_app/features/coffee/presentation/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          "Transaction History",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: AppColors.background,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => controller.downloadPdf(),
              icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.kPrimaryColor),
              tooltip: 'Download PDF',
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
          );
        }

        if (controller.expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    size: 60,
                    color: AppColors.kPrimaryColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "No transactions yet!",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your orders will appear here.",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          );
        }

        // Calculate totals for summary
        final totalSpent = controller.expenses.fold<double>(
          0, (sum, item) => sum + item.totalPrice,
        );
        final totalOrders = controller.expenses.length;

        return RefreshIndicator(
          onRefresh: () => controller.fetchExpenses(),
          color: AppColors.kPrimaryColor,
          backgroundColor: AppColors.cardBackground,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Summary Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.kPrimaryColor,
                          AppColors.kPrimaryColor.withRed(255).withGreen(150),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kPrimaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Spending",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\$${totalSpent.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(color: Colors.white.withOpacity(0.2)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomExpenseItem(
                              icon: Icons.shopping_bag_rounded,
                              label: "Total Orders",
                              value: totalOrders.toString(),
                            ),
                            CustomExpenseItem(
                              icon: Icons.stars_rounded,
                              label: "Loyalty Points",
                              value: (totalSpent * 10).toInt().toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Recent Orders Label
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    "Order History",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // List of Orders
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final expense = controller.expenses[index];
                    final date = expense.orderDate ?? DateTime.now();

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.kPrimaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            expense.paymentMethod.toLowerCase().contains('cash')
                                ? Icons.payments_rounded
                                : Icons.credit_card_rounded,
                            color: AppColors.kPrimaryColor,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          "\$${expense.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "${date.day}/${date.month}/${date.year} • ${expense.totalItems} Items",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        trailing: const Icon(Icons.expand_more_rounded, color: AppColors.textSecondary),
                        children: [
                          ...expense.items.map((item) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.image,
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 45,
                                    height: 45,
                                    color: Colors.grey[800],
                                    child: const Icon(Icons.coffee_rounded, color: Colors.white54, size: 20),
                                  ),
                                ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "x${item.quantity} • \$${item.totalItemPrice.toStringAsFixed(2)}",
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            );
                          }).toList(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Store Info", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                      Text(expense.storeName ?? "Online Order", style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  Text(
                                    expense.paymentMethod,
                                    style: TextStyle(
                                      color: AppColors.kPrimaryColor.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: controller.expenses.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      }),
    );
  }

  
}
