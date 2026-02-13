class ExpenseItemEntity {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final int quantity;
  final double totalItemPrice;
  final String image;

  ExpenseItemEntity({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.totalItemPrice,
    required this.image,
  });
}