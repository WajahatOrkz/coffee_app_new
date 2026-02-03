import 'package:coffee_app/features/auth/presentation/bindings/auth_binding.dart';
import 'package:coffee_app/features/auth/presentation/bindings/splash.dart';
import 'package:coffee_app/features/coffee/presentation/bindings/coffee_binding.dart';

import 'package:coffee_app/features/coffee/presentation/views/cart.dart';
import 'package:coffee_app/features/coffee/presentation/views/coffee_home.dart';
import 'package:coffee_app/features/auth/presentation/views/login.dart';
import 'package:coffee_app/features/auth/presentation/views/signup.dart';
import 'package:coffee_app/features/auth/presentation/views/splash.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.kSplashRoute,
      page: () => SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.kLoginRoute,
      page: () =>  LoginView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.kSignUpRoute,
      page: () => const SignUpView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.kHomeCoffeeRoute,
      page: () => CoffeeHomeView(),
      binding: CoffeeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRoutes.kCartRoute,
      page: () => CartScreen(),
      binding: CoffeeBinding(),
      transition: Transition.noTransition,
    ),
    
  ];
}
