part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class Loading extends ProductState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class ProductsLoadedSuccess extends ProductState {

  final List<Product> products;
  final int total;
  final int page;

  ProductsLoadedSuccess(this.products, this.total, this.page);

  @override
  List<Object?> get props => [products, total, page];
}

// When the user is authenticated the state is changed to Authenticated.
class NoFilterToLoad extends ProductState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class NoProductsToLoad extends ProductState {
  @override
  List<Object?> get props => [];
}

// When the user is authenticated the state is changed to Authenticated.
class NoProductsRecentlyLoaded extends ProductState {
  @override
  List<Object?> get props => [];
}


// When the user is authenticated the state is changed to Authenticated.
class ProductsDiscardingAll extends ProductState {
  @override
  List<Object?> get props => [];
}

class ProductOpenLinkReady extends ProductState {
  final String link;
  final int code;

  ProductOpenLinkReady(this.code, this.link);
  @override
  List<Object?> get props => [link, code];
}


// If any error occurs the state is changed to AuthError.
class ProductsError extends ProductState {
  final String error;

  ProductsError(this.error);
  @override
  List<Object?> get props => [error];
}
