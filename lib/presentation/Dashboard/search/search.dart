import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garimpoo/bloc/product_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/auth_bloc.dart';
import '../../../model/Product.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchSignUpState();
}

class ButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(size.width);
    var path = new Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width /
            (size.width <= 142
                ? 5
                : size.width > 142 && size.width <= 195
                    ? 6.1
                    : 7.5),
        size.height / 2,
        0,
        0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(ButtonClipper oldClipper) => false;
}

class ButtonClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        size.width /
            (size.width <= 142
                ? 1.25
                : size.width > 142 && size.width <= 195
                    ? 1.19
                    : 1.16),
        size.height / 2,
        size.width,
        size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(ButtonClipper2 oldClipper) => false;
}

class _SearchSignUpState extends State<Search> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(ProductLoad());
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProductBloc, ProductState>(builder: (context, state) {


      logger.i(state);
      if (state is NoFilterToLoad) {
        return Container(
            color: Colors.grey.shade100.withOpacity(1),
            height: double.infinity,
            width: double.infinity,
            child: Center(
                child: Text(
                  'Adicione alguma palavre-chave para poder pesquisar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                )));
      }

      if (state is NoProductsToLoad) {
        return Container(
            color: Colors.grey.shade100.withOpacity(1),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: IconButton(
                      iconSize: 75,
                      icon: ImageIcon(
                        AssetImage('images/refresh.png'),
                      ),
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context)
                            .add(ProductLoad());
                      }),
                ),
                Center(
                    child: Text(
                      'Ops...\nNenhum resultado encontrado',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ));
      }

      if (state is NoProductsRecentlyLoaded) {
        return Container(
            color: Colors.grey.shade100.withOpacity(1),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: IconButton(
                      iconSize: 75,
                      icon: ImageIcon(
                        AssetImage('images/refresh.png'),
                      ),
                      onPressed: () {
                        BlocProvider.of<ProductBloc>(context)
                            .add(ProductLoad());
                      }),
                ),
                Center(
                    child: Text(
                      'Caso mude de ideia,\nverifique a aba de Descartes',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ));
      }
      if (state is Loading) {
        return Container(
            color: Colors.grey.shade100.withOpacity(1),
            height: double.infinity,
            width: double.infinity,
            child: Center(
                child: Image.asset(
                  "images/pickaxe_loading.gif",
                )));
      }

      if (state is ProductsDiscardingAll) {
        return Container(
          color: Colors.grey.shade100.withOpacity(1),
          height: double.infinity,
          width: double.infinity,
          child: Center(
              child: Image.asset(
                "images/explosao.gif",
              )),
        );
      }

      if (state is ProductsLoadedSuccess) {
        return Scaffold(
            body: dataBody(state.products, state.total, state.page));
      }
      return Container();
    }, listener: (context, state) {

    });

  }

  final ItemScrollController _scrollController = ItemScrollController();

  ScrollablePositionedList dataBody(
      List<Product> products, int total, int page) {
    return ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          return index == products.length
              ? Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          left: 0,
                          right: (MediaQuery.of(context).size.width / 2) + 14,
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: 4, top: 4, bottom: 4),
                              child: Container(
                                transform: Matrix4.translationValues(0, 0, 0),
                                child: ClipPath(
                                  clipper: ButtonClipper2(),
                                  child: Container(
                                    color: Colors.red,
                                    child: RawMaterialButton(
                                      child: Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: new RichText(
                                            text: new TextSpan(
                                              // Note: Styles for TextSpans must be explicitly defined.
                                              // Child text spans will inherit styles from parent
                                              style: new TextStyle(
                                                fontFamily: "Lexend",
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                new TextSpan(
                                                    text: 'Descartar '),
                                                new TextSpan(
                                                    text: "(-" +
                                                        products.length
                                                            .toString() +
                                                        ")",
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          )),
                                      onPressed: () {
                                        BlocProvider.of<ProductBloc>(context)
                                            .add(ProductDiscardEvent(products));
                                      },
                                    ),
                                  ),
                                ),
                              ))),
                      Positioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Material(
                            color: Colors.red,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: ImageIcon(
                                  AssetImage("./images/explosao.png"),
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              onTap: () {
                                BlocProvider.of<ProductBloc>(context)
                                    .add(ProductDiscardAllEvent());
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          left: (MediaQuery.of(context).size.width / 2) + 14,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 4, left: 0, top: 4, bottom: 4),
                            child: Container(
                              transform: Matrix4.translationValues(0, 0, 0),
                              child: Visibility(
                                  visible: (total - products.length) > 0,
                                  child: ClipPath(
                                    clipper: ButtonClipper(),
                                    child: Container(
                                      color: Colors.green,
                                      child: RawMaterialButton(
                                        child: Container(
                                            height: 40,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 0),
                                              child: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: TextStyle(
                                                      fontFamily: "Lexend",
                                                      color: Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'Carregar '),
                                                      TextSpan(
                                                          text: "(+" +
                                                              (total -
                                                                      products
                                                                          .length)
                                                                  .toString() +
                                                              ")",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )),
                                        onPressed: () {
                                          BlocProvider.of<ProductBloc>(context)
                                              .add(ProductLoadMore(
                                                  products, page));
                                        },
                                      ),
                                    ),
                                  )),
                            ),
                          ))
                    ],
                  ))
              : GestureDetector(
                  onTap: () {
                     launch(products[index].permaLink!, forceSafariVC: false);
                  },
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 90,
                                height: 90,
                                child: products[index].thumbnail != null
                                    ? Image.network(products[index]
                                        .thumbnail!)
                                    : null),
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                          "R\$ " +
                                              products[index].price.toString(),
                                          style: TextStyle(
                                              fontSize: 26,
                                              color: Colors.black54)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Text(products[index].title!,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ))),
                                    ],
                                  )),
                            ),
                          ])));
        });
  }
}
