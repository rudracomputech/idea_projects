import 'dart:convert';

import 'package:ready_ecommerce/models/eCommerce/product/product.dart'
    as product;
import 'package:ready_ecommerce/models/eCommerce/shop/shop_details.dart';

import '../category/category.dart';
import '../shop/shop.dart';

class Dashboard {
  final List<Banner> banners;
  final List<Banner> ads;
  final List<Category> categories;
  final List<product.Product> popularProducts;
  final List<Shop> shops;
  final JustForYou justForYou;
  final List<CategoryFilter> qualities;
  final List<CategoryFilter> season;
  Dashboard({
    required this.banners,
    required this.ads,
    required this.categories,
    required this.popularProducts,
    required this.shops,
    required this.justForYou,
    required this.qualities,
    required this.season,
  });

  Dashboard copyWith({
    List<Banner>? banners,
    List<Banner>? ads,
    List<Category>? categories,
    List<product.Product>? popularProducts,
    List<Shop>? shops,
    JustForYou? justForYou,
    List<CategoryFilter>? qualities,
    List<CategoryFilter>? season,
  }) {
    return Dashboard(
      banners: banners ?? this.banners,
      ads: ads ?? this.ads,
      categories: categories ?? this.categories,
      shops: shops ?? this.shops,
      popularProducts: popularProducts ?? this.popularProducts,
      justForYou: justForYou ?? this.justForYou,
      qualities: qualities ?? this.qualities,
      season: season ?? this.season,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'banners': banners.map((x) => x.toMap()).toList(),
      'ads': ads.map((x) => x.toMap()).toList(),
      'categories': categories.map((x) => x.toMap()).toList(),
      'popularProducts': popularProducts.map((x) => x.toMap()).toList(),
      'justForYou': justForYou.toMap(),
      'qualities': qualities.map((x) => x.toMap()).toList(),
      'seasons': season.map((x) => x.toMap()).toList(),
    };
  }

  factory Dashboard.fromMap(Map<String, dynamic> map) {
    return Dashboard(
      banners: List<Banner>.from(
        (map['banners'] as List<dynamic>).map<Banner>(
          (x) => Banner.fromMap(x as Map<String, dynamic>),
        ),
      ),
      ads: List<Banner>.from(
        (map['ads'] as List<dynamic>).map<Banner>(
          (x) => Banner.fromMap(x as Map<String, dynamic>),
        ),
      ),
      qualities: List<CategoryFilter>.from(
        (map['filter_categories']["qualities"]["items"] as List<dynamic>)
            .map<CategoryFilter>(
          (x) => CategoryFilter.fromMap(x as Map<String, dynamic>),
        ),
      ),
      season: List<CategoryFilter>.from(
        (map['filter_categories']["seasons"]["items"] as List<dynamic>)
            .map<CategoryFilter>(
          (x) => CategoryFilter.fromMap(x as Map<String, dynamic>),
        ),
      ),
      categories: List<Category>.from(
        (map['categories'] as List<dynamic>).map<Category>(
          (x) => Category.fromMap(x as Map<String, dynamic>),
        ),
      ),
      shops: List<Shop>.from(
        (map['shops'] as List<dynamic>).map<Shop>(
          (x) => Shop.fromMap(x as Map<String, dynamic>),
        ),
      ),
      popularProducts: List<product.Product>.from(
        (map['popular_products'] as List<dynamic>).map<product.Product>(
          (x) => product.Product.fromMap(x as Map<String, dynamic>),
        ),
      ),
      justForYou:
          JustForYou.fromMap(map['just_for_you'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Dashboard.fromJson(String source) =>
      Dashboard.fromMap(json.decode(source) as Map<String, dynamic>);
}

class JustForYou {
  final int total;
  List<product.Product> products;
  JustForYou({
    required this.total,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory JustForYou.fromMap(Map<String, dynamic> map) {
    return JustForYou(
      total: map['total'] as int,
      products: List<product.Product>.from(
        (map['products'] as List<dynamic>)
            .where((x) => (x as Map<String, dynamic>)['quantity'] != 0)
            .map<product.Product>(
              (x) => product.Product.fromMap(x as Map<String, dynamic>),
            ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory JustForYou.fromJson(String source) =>
      JustForYou.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CategoryFilter {
  final int id;
  final String? title;
  final int? count;
  CategoryFilter({
    required this.id,
    required this.title,
    required this.count,
  });

  CategoryFilter copyWith({int? id, String? title, int? count}) {
    return CategoryFilter(
      id: id ?? this.id,
      title: title ?? this.title,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': title,
      'count': count,
    };
  }

  factory CategoryFilter.fromMap(Map<String, dynamic> map) {
    return CategoryFilter(
      id: map['id'].toInt() as int,
      title: map['name'] ?? '',
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryFilter.fromJson(String source) =>
      CategoryFilter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Banner(id: $id, title: $title, thumbnail: $count)';

  @override
  bool operator ==(covariant Banner other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ count.hashCode;
}
