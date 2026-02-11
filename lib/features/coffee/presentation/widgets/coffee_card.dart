import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/coffee_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoffeeCard extends GetView<CoffeeController> {
   final CoffeeEntity coffeeData;


  const CoffeeCard({super.key, required this.coffeeData});
  

  @override
  Widget build(BuildContext context) {
     return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coffee Image with Rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  coffeeData.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[800],
                      child: Icon(Icons.coffee, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: AppColors.kPrimaryColor, size: 14),
                      SizedBox(width: 4),
                      Text(
                        coffeeData.rating.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Coffee Details
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coffeeData.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  coffeeData.subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${coffeeData.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.addToCart(coffeeData),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
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
  }
}