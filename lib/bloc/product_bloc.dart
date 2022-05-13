import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garimpoo/local_storage/local_storage_repository.dart';
import 'package:garimpoo/repository/auth_repository.dart';
import 'package:garimpoo/repository/client_repository.dart';
import 'package:meta/meta.dart';

import '../model/Product.dart';
import '../shared/Credentials.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ClientRepository clientRepository;
  final AuthRepository authRepository;

  ProductBloc({required this.clientRepository, required this.authRepository})
      : super(Loading()) {
    on<ProductLoad>((event, emit) async {
      try {
        if (Credentials().filter!.keywords?.length == 0) {
          emit(NoFilterToLoad());
        } else {
          emit(Loading());
          await authRepository.refreshToken();
          ProductResponse product = await clientRepository.getAll(
              LocalStorageShared.instance.getString("X-Firebase-Auth")!);

          if (product.total == 0) {
            emit(NoProductsToLoad());
          } else {
            List<Product> products = [];

            products.addAll(product.products);

            emit(ProductsLoadedSuccess(products, product.total, 0, 0));
          }
        }
      } catch (e) {
        emit(ProductsError(e.toString()));
      }
    });

    on<ProductLoadMore>((event, emit) async {
      try {
        emit(Loading());
        await authRepository.refreshToken();

        int nextPage = event.page + 1;

        ProductResponse product = await clientRepository.getPage(
            LocalStorageShared.instance.getString("X-Firebase-Auth")!,
            nextPage);

        List<Product> products = List.from(event.products);
        products.addAll(product.products);

        emit(ProductsLoadedSuccess(products, product.total, nextPage, event.products.length));
      } catch (e) {
        emit(ProductsError(e.toString()));
      }
    });

    on<ProductDiscardEvent>((event, emit) async {
      try {
        emit(ProductsDiscardingAll());

        ProductDiscardRequest request = ProductDiscardRequest(
            products: event.products
                .map((Product el) => ProductDiscard(id: el.id))
                .toList());

        await authRepository.refreshToken();
        ProductResponse product = await clientRepository.discardProducts(
            LocalStorageShared.instance.getString("X-Firebase-Auth")!, request);

        if (product.total == 0) {
          emit(NoProductsRecentlyLoaded());
        } else {
          List<Product> products = [];

          products.addAll(product.products);

          emit(ProductsLoadedSuccess(products, product.total, 0, 0));
        }
      } catch (e) {
        emit(ProductsError(e.toString()));
      }
    });

    on<ProductDiscardAllEvent>((event, emit) async {
      try {
        emit(ProductsDiscardingAll());
        await authRepository.refreshToken();
        await clientRepository.discardAllProducts(
            LocalStorageShared.instance.getString("X-Firebase-Auth")!);

        emit(NoProductsRecentlyLoaded());
      } catch (e) {
        emit(ProductsError(e.toString()));
      }
    });

  }
}
