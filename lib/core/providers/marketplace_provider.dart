import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';

final sampleProducts = [
  // 1. Books
  const Product(
    id: 'p1',
    title: 'Organic Chemistry, 10th Edition',
    price: 45.00,
    category: 'Books',
    condition: 'Like New',
    description: 'Minimal highlighting, excellent condition for CHEM101 and CHEM202. Hardcover edition.',
    imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80',
    sellerName: 'Sarah J.',
    sellerCampus: 'North Campus',
  ),
  const Product(
    id: 'p2',
    title: 'Introduction to Linear Algebra, 5th Ed',
    price: 50.00,
    category: 'Books',
    condition: 'Good',
    description: 'Required textbook for MATH 220. Includes solution manual pdf.',
    imageUrl: 'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=600&q=80',
    sellerName: 'Alex R.',
    sellerCampus: 'Engineering Quad',
  ),

  // 2. Stationery
  const Product(
    id: 'p3',
    title: 'TI-84 Plus CE Graphing Calculator',
    price: 85.00,
    category: 'Stationery',
    condition: 'Like New',
    description: 'Rechargeable battery, high-resolution color screen. Essential for math & engineering.',
    imageUrl: 'https://images.unsplash.com/photo-1594980596870-8aa52a78d8cd?auto=format&fit=crop&w=600&q=80',
    sellerName: 'Michael R.',
    sellerCampus: 'Main Campus',
  ),
  const Product(
    id: 'p4',
    title: 'Premium Stationery Bundle (Unused)',
    price: 20.00,
    category: 'Stationery',
    condition: 'Brand New',
    description: 'Highlighters, notebook set, sticky notes, and gel pens in an organized pouch.',
    imageUrl: 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?auto=format&fit=crop&w=600&q=80',
    sellerName: 'Lisa W.',
    sellerCampus: 'Engineering Annex',
  ),

  // 3. Notes
  const Product(
    id: 'p5',
    title: 'Complete Bio 101 Lecture Notes (Digital PDF)',
    price: 15.00,
    category: 'Notes',
    condition: 'Digital',
    description: 'Comprehensive semester lecture notes, diagrams, and exam preparation guides.',
    imageUrl: 'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=600&q=80',
    sellerName: 'David K.',
    sellerCampus: 'East Dorms',
  ),
  const Product(
    id: 'p6',
    title: 'CS 106A Python Midterm & Final Notes',
    price: 18.00,
    category: 'Notes',
    condition: 'Digital',
    description: 'Clean cheat sheets, solved lab assignments, and mock exam questions with answers.',
    imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=600&q=80',
    sellerName: 'Jessica T.',
    sellerCampus: 'Computer Science Dept',
  ),

  // 4. Digital Services
  const Product(
    id: 'p7',
    title: 'Python & Java Programming Tutoring (1-on-1)',
    price: 25.00,
    category: 'Digital Services',
    condition: 'Service',
    description: 'Experienced CS TA offering personalized 1-on-1 code debugging and project assistance.',
    imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=600&q=80',
    sellerName: 'Ethan B.',
    sellerCampus: 'Student Center',
  ),
  const Product(
    id: 'p8',
    title: 'Resume & Student Portfolio Design Review',
    price: 30.00,
    category: 'Digital Services',
    condition: 'Service',
    description: 'Get your tech/design resume reviewed by a senior student who landed Big Tech internships.',
    imageUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=600&q=80',
    sellerName: 'Chloe M.',
    sellerCampus: 'Design Lab',
  ),
];

class MarketplaceNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() => sampleProducts;

  void addProduct(Product product) {
    state = [product, ...state];
  }
}

final marketplaceProvider = NotifierProvider<MarketplaceNotifier, List<Product>>(MarketplaceNotifier.new);

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All Categories';

  void setCategory(String category) => state = category;
}

final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);
