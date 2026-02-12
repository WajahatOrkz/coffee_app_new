import 'package:cloud_firestore/cloud_firestore.dart';
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
        automaticallyImplyActions: false,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.textPrimary,)),
        title: const Text("Order History",style: TextStyle(color: AppColors.textPrimary),),backgroundColor: AppColors.background,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.expenses.isEmpty) {
          return const Center(child: Text("No transactions yet!",style: TextStyle(color: AppColors.textPrimary),));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchExpenses(),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.expenses.length,
            itemBuilder: (context, index) {
              final expense = controller.expenses[index];
              print("=====================<<<<<<<<<<<<expesne Item : $expense>>>>>>>====================");
              final date = expense['orderDate'] != null 
              ? (expense['orderDate'] as Timestamp).toDate() 
              : DateTime.now();
          
              return Card(
                
                color: AppColors.cardBackground,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text("Total: \$${expense['totalPrice']}",style: TextStyle(color: AppColors.textSecondary),),
                  subtitle: Text("Date: ${date.toLocal().toString().split('.')[0] }",style: TextStyle(color: AppColors.textSecondary),),
                  children: [
                    ...(expense['items'] as List).map((item) => ListTile(
                          leading: CircleAvatar(backgroundImage: NetworkImage(item['image'])),
                          title: Text(item['name'],style: TextStyle(color: AppColors.textSecondary),),
                          trailing: Text("x${item['quantity']} - \$${item['totalItemPrice']}",style: TextStyle(color: AppColors.kPrimaryColor),),
                        ),),
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