// lib/features/coffee/presentation/views/expense_view.dart

import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          "Order History",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            onPressed: () {
              controller.downloadPdf();
            },
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.expenses.isEmpty) {
          return const Center(
            child: Text(
              "No transactions yet!",
              style: TextStyle(color: AppColors.textPrimary),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchExpenses(),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.expenses.length,
            itemBuilder: (context, index) {
             
              final expense = controller.expenses[index];
              
              //
              final date = expense.orderDate ?? DateTime.now();

              return Card(
                color: AppColors.cardBackground,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  
                  title: Text(
                    "Total: \$${expense.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date: ${date.toLocal().toString().split('.')[0]}",
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Payment: ${expense.paymentMethod}",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "Items: ${expense.totalItems} | Subtotal: \$${expense.subtotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    // ✅ Loop through items (ExpenseItemEntity list)
                    ...expense.items.map((item) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.image),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        subtitle: Text(
                          item.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Text(
                          "x${item.quantity} - \$${item.totalItemPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: AppColors.kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                    
                   
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal:",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                "\$${expense.subtotal.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tax (${expense.taxRate}):",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                "\$${expense.taxAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "\$${expense.totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: AppColors.kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}