

import 'package:coffee_app/features/coffee/domain/repositories/coffee_repository.dart';

import '../../domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/store_entity.dart';

import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';

import '../models/coffee_model.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  final FirestoreRepository firestoreRepository;

  CoffeeRepositoryImpl({required this.firestoreRepository});
  
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

final List<Map<String, dynamic>> _dummyData2 = [
  {
    'id': '1',
    'name': 'Spanish Latte',
    'subtitle': 'With Condensed Milk',
    'price': 5.40,
    'image': 'https://images.unsplash.com/photo-1521305916504-4a1121188589?w=400',
    'rating': 4.6,
    'category': 'Latte',
  },
  {
    'id': '2',
    'name': 'Turkish Coffee',
    'subtitle': 'Strong & Traditional',
    'price': 4.10,
    'image': 'https://images.unsplash.com/photo-1497636577773-f1231844b336?w=400',
    'rating': 4.4,
    'category': 'Espresso',
  },
  {
    'id': '3',
    'name': 'Irish Coffee',
    'subtitle': 'With Cream Layer',
    'price': 6.90,
    'image': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=400',
    'rating': 4.7,
    'category': 'Special',
  },
  {
    'id': '4',
    'name': 'Affogato',
    'subtitle': 'Espresso with Ice Cream',
    'price': 5.80,
    'image': 'https://images.unsplash.com/photo-1470337458703-46ad1756a187?w=400',
    'rating': 4.8,
    'category': 'Dessert',
  },
  {
    'id': '5',
    'name': 'Matcha Latte',
    'subtitle': 'Green Tea Blend',
    'price': 5.20,
    'image': 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400',
    'rating': 4.5,
    'category': 'Latte',
  },
  {
    'id': '6',
    'name': 'Iced Caramel Latte',
    'subtitle': 'With Ice & Caramel',
    'price': 6.10,
    'image': 'https://images.unsplash.com/photo-1509042239860-7b3f9c58d3b0?w=400',
    'rating': 4.6,
    'category': 'Cold',
  },
  {
    'id': '7',
    'name': 'Flat White',
    'subtitle': 'Velvety Microfoam',
    'price': 4.60,
    'image': 'https://images.unsplash.com/photo-1509785307050-d4066910ec1e?w=400',
    'rating': 4.3,
    'category': 'Espresso',
  },
  {
    'id': '8',
    'name': 'Cold Brew Tonic',
    'subtitle': 'With Sparkling Water',
    'price': 6.75,
    'image': 'https://images.unsplash.com/photo-1510627498534-cf7e9002facc?w=400',
    'rating': 4.7,
    'category': 'Cold',
  },
];

final List<Map<String, dynamic>> _dummyData3 = [
  {
    'id': '1',
    'name': 'Honey Latte',
    'subtitle': 'With Organic Honey',
    'price': 5.30,
    'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
    'rating': 4.5,
    'category': 'Latte',
  },
  {
    'id': '2',
    'name': 'Cortado',
    'subtitle': 'Equal Espresso & Milk',
    'price': 4.20,
    'image': 'https://images.unsplash.com/photo-1498804103079-a6351b050096?w=400',
    'rating': 4.4,
    'category': 'Espresso',
  },
  {
    'id': '3',
    'name': 'Nitro Cold Brew',
    'subtitle': 'Infused with Nitrogen',
    'price': 6.95,
    'image': 'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=400',
    'rating': 4.8,
    'category': 'Cold',
  },
  {
    'id': '4',
    'name': 'Pumpkin Spice Latte',
    'subtitle': 'Seasonal Special',
    'price': 6.40,
    'image': 'https://images.unsplash.com/photo-1507914372368-b2b085b925a1?w=400',
    'rating': 4.7,
    'category': 'Special',
  },
  {
    'id': '5',
    'name': 'Mocha Frappe',
    'subtitle': 'Blended Iced Coffee',
    'price': 6.85,
    'image': 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=400',
    'rating': 4.6,
    'category': 'Cold',
  },
];

  @override
  Future<List<CoffeeEntity>> getCoffeeList({String? storeId}) async {
    if (storeId != null && storeId.isNotEmpty) {
      try {
        final products = await firestoreRepository.getProducts(storeId);
        if (products.isNotEmpty) {
           return products;
        }
      } catch (e) {
        print("Error fetching from Firestore for store $storeId: $e");
        // Fallback or rethrow? 
        // For now, if empty or error, maybe fallback to dummy if appropriate, 
        // but user wants specific data.
      }
    }
    
    // Fallback if no storeId or firestore fail (or empty)
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));
    
    // Convert Model to Entity
    return _dummyData.map((json) => CoffeeModel.fromJson(json).toEntity()).toList();
  }

  @override
  Future<void> seedData() async {
    try {
      var stores = await firestoreRepository.getStores();
      
      // ✅ Step 1: Create Stores if missing
      if (stores.isEmpty) {
        print("No stores found. Creating dummy stores...");
        final dummyStores = [
          StoreEntity(id: 'store_1', name: 'Downtown Cafe', address: '123 Main St'),
          StoreEntity(id: 'store_2', name: 'Uptown Brews', address: '456 High St'),
          StoreEntity(id: 'store_3', name: 'Lakeside Coffee', address: '789 Lake Dr'),
        ];

        for (var store in dummyStores) {
          await firestoreRepository.addStore(store);
        }
        
        // Refresh stores list after adding
        stores = await firestoreRepository.getStores();
      }

      if (stores.isEmpty) {
         print("Still no stores after seeding attempts.");
         return;
      }

      // ✅ Step 2: Seed Products for each store
      // stores are not guaranteed to be in order, so we map by ID or just index if we used consistent IDs above.
      // Since we just added them with specific IDs or Firestore generated them, let's just use index for simplicity 
      // as long as we have 3 stores.

      if (stores.isNotEmpty) {
        final store = stores[0]; 
        final products = _dummyData.map((json) => CoffeeModel.fromJson(json).toEntity()).toList();
        await firestoreRepository.saveProducts(store.id, products);
        print("Seeded data for Store 1 (${store.name})");
      }

      if (stores.length > 1) {
        final store = stores[1];
        final products = _dummyData2.map((json) => CoffeeModel.fromJson(json).toEntity()).toList();
        await firestoreRepository.saveProducts(store.id, products);
        print("Seeded data for Store 2 (${store.name})");
      }
      
      if (stores.length > 2) {
        final store = stores[2];
        final products = _dummyData3.map((json) => CoffeeModel.fromJson(json).toEntity()).toList();
        await firestoreRepository.saveProducts(store.id, products);
        print("Seeded data for Store 3 (${store.name})");
      }

    } catch (e) {
      print("Error seeding data: $e");
      rethrow;
    }
  }

 
}