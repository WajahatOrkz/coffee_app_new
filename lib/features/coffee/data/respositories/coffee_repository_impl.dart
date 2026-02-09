

import 'package:coffee_app/features/coffee/domain/repositories/coffee_repository.dart';

import '../../domain/entities/coffee_entity.dart';

import '../models/coffee_model.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  
  // Dummy API data
  final List<Map<String, dynamic>> _dummyData = [
    {
      'id': '1',
      'name': 'Espresso',
      'subtitle': 'With Oat Milk',
      'price': 1.25,
      'image': 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
      'rating': 1.5,
      'category': 'Espresso',
    },
    {
      'id': '2',
      'name': 'Flat White',
      'subtitle': 'With Oat Milk',
      'price': 2.25,
      'image': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
      'rating': 4.2,
      'category': 'Espresso',
    },
    {
      'id': '3',
      'name': 'Espresso',
      'subtitle': 'With Oat Milk',
      'price': 4.25,
      'image': 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=400',
      'rating': 4.8,
      'category': 'Espresso',
    },
    {
      'id': '4',
      'name': 'Espresso',
      'subtitle': 'With Oat Milk',
      'price': 5.25,
      'image': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      'rating': 4.3,
      'category': 'Espresso',
    },
    {
      'id': '5',
      'name': 'Cappuccino',
      'subtitle': 'With Steamed Milk',
      'price': 6.50,
      'image': 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
      'rating': 4.6,
      'category': 'Cappuccino',
    },
    {
      'id': '6',
      'name': 'Cappuccino',
      'subtitle': 'With Foam',
      'price': 7.75,
      'image': 'https://images.unsplash.com/photo-1534778101976-62847782c213?w=400',
      'rating': 4.4,
      'category': 'Cappuccino',
    },
    {
      'id': '7',
      'name': 'Cold Brew',
      'subtitle': 'Iced Coffee',
      'price': 8.99,
      'image': 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
      'rating': 4.7,
      'category': 'Cold',
    },
    {
      'id': '8',
      'name': 'Iced Latte',
      'subtitle': 'With Ice',
      'price': 9.25,
      'image': 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
      'rating': 4.5,
      'category': 'Cold',
    },
  ];

  @override
  Future<List<CoffeeEntity>> getCoffeeList() async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));
    
    // Convert Model to Entity
    return _dummyData.map((json) => CoffeeModel.fromJson(json).toEntity()).toList();
  
  }

 
}