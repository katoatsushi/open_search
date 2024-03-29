import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'map/tapListener.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

import 'package:open_search/model/gcs.dart';
import 'package:open_search/env/env.dart';
import 'package:google_place/google_place.dart';
import 'package:open_search/views/targetPlaceCard.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:open_search/views/map/modal/uiParts/myProfileCard.dart';
import 'package:open_search/views/map/modal/accountInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({Key? key}) : super(key: key);

  @override
  State<MapComponent> createState() => MapComponentState();
}

class MapComponentState extends State<MapComponent> {
  // GCS データを取得する
  final GCSModel gcsModel = GCSModel();

  final Completer<GoogleMapController> _controller = Completer();
  final markers = [];
  final zoomLevelSearchDone = 17.30;

  late LatLng _initialPosition;
  bool _loading = false;
  bool _onTapped = false;
  double _tagRightFrom = 0.0;
  double _tagTopFrom = 0.0;
  BitmapDescriptor? pinLocationIcon = null;
  double zoomLevel = 10.0;
  late LatLng cameraPosition;
  List<bool> isSelected = [true, false];
  MapType selectedMapType = MapType.normal;
  List<SearchResult>? nearByPredictions = [];
  bool isSearching = false;
  SearchResult? searchedTarget;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? currentUser;

  @override
  void initState() {
    // init Google Place
    googlePlace = GooglePlace(apiKey);
    super.initState();
    final User? user = auth.currentUser;
    _loading = true;
    // setState(() {});

    setState(() {
      currentUser = user;
    });
    Future(() async {
      // BitmapDescriptor newIcon = await setCustomMapPin();
      await _isUserDocExist(user);

      await _getUserLocation();
      BitmapDescriptor icon =
          await getBitmapDescriptorFromAssetBytes("assets/sayhi.jpeg", 150);

      setState(() {
        pinLocationIcon = icon;
      });
    });
  }

  Future<void> _isUserDocExist(User? user) async {
    final db =
        FirebaseFirestore.instanceFor(app: Firebase.app(), databaseURL: "main");
    final userDocRef = db.collection('users').doc(user?.uid);

    final userDocQuery = await userDocRef.get();

    if (userDocQuery.exists) {
      print(userDocQuery);
    } else {
      await userDocRef.set({});
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効かどうかをテストします。
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 拒否された場合エラーを返す
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // ここまでたどり着くと、位置情報に対しての権限が許可されているということなので
    // デバイスの位置情報を返す。
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    Position position = await _determinePosition();

    setState(() {
      // SET CURRENT POSITION ON TOKYO = (35.6895, 139.69171)
      _initialPosition = LatLng(35.6895, 139.69171);
      cameraPosition = LatLng(35.6895, 139.69171);
      // _initialPosition = LatLng(position.latitude, position.longitude);
      print(position);
    });
    _loading = false;
  }

  // Future<BitmapDescriptor> setCustomMapPin() async {
  //   pinLocationIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(size: const 150), 'assets/sayhi.jpeg');
  //   return pinLocationIcon!;
  // }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return byteData.buffer.asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  List<Widget> zoomGuidLine(screenWidth, screenHeight) {
    return ([
      CustomPaint(
        painter: MountainPainter(
          rightFrom: _tagRightFrom,
          topFrom: _tagTopFrom,
        ),
      ),
      Positioned(
        right: 0.0,
        bottom: 80.0,
        child: GestureDetector(
          onTap: () {
            print("onTap");
            setState(() {
              _onTapped = true;
              _tagRightFrom = 0;
              _tagTopFrom = 0;
            });
          },
          onVerticalDragUpdate: (DragUpdateDetails details) async {
            print('onVerticalDragUpdate: _onTapped: ${_onTapped}');
            final GoogleMapController controller = await _controller.future;
            double currentZoomLevel = await controller.getZoomLevel();
            double desiredZoomLevel = currentZoomLevel + details.delta.dy * 0.1;
            controller.animateCamera(CameraUpdate.zoomTo(desiredZoomLevel));
            print("currentZoomLevel is $currentZoomLevel");
            setState(() {
              _tagRightFrom = screenWidth - details.globalPosition.dx;
              _tagTopFrom = screenHeight - details.globalPosition.dy;
              zoomLevel = currentZoomLevel;
            });
          },
          onVerticalDragDown: (DragDownDetails details) {
            print("onVerticalDragDown: _onTapped: ${_onTapped}");
          },
          onVerticalDragStart: (DragStartDetails details) {
            print("onVerticalDragStart: _onTapped: ${_onTapped}");
            setState(() {
              _onTapped = true;
            });
          },
          onVerticalDragEnd: (DragEndDetails details) {
            print("onVerticalDragEnd: _onTapped: ${_onTapped}");
            setState(() {
              _tagRightFrom = 0;
              _tagTopFrom = 0;
              _onTapped = false;
            });
          },
          onVerticalDragCancel: () {
            print("onVerticalDragCancel");
            setState(() {
              _onTapped = false;
            });
          },
          child: Container(
            color: Colors.blue.withOpacity(0.4),
            width: 50,
            height: 600,
          ),
        ),
      ),
    ]);
  }

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = []; // predictionsに検索結果を格納
  final String apiKey = Env.key;
  void autoCompleteSearch(String value) async {
    final result = await googlePlace.autocomplete.get(value);

    if (result != null && result.predictions != null && mounted) {
      print(result.predictions?[0]);
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void searchNearByPlace(String keyWord) async {
    if (keyWord != '') {
      final result = await googlePlace.search.getNearBySearch(
        language: 'ja',
        Location(
            lat: _initialPosition.latitude, lng: _initialPosition.longitude),
        10000, //TODO 距離
        // type: 'restaurant',
        keyword: keyWord,
      );
      print(result?.results);
      List<SearchResult> searchResult = [];
      if (result != null && result.results != null) {
        searchResult = result.results!;
      }

      setState(() {
        nearByPredictions = searchResult;
      });
    }
  }

  // 選択した場所を表示とzoomを設定
  Future<void> _changePosition(LatLng latLng, double zoom) async {
    if (latLng != null) {
      final completer = await _controller.future;
      final cameraPosition = CameraPosition(target: latLng, zoom: zoom);
      await completer
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Container(
      // height: 600,
      child: _loading
          ? const Center(
              child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ))
          :
          // SafeArea( child:
          Stack(
              fit: _onTapped ? StackFit.expand : StackFit.loose,
              children: [
                GoogleMap(
                  // mapType: MapType.hybrid,
                  mapType: selectedMapType,
                  // 検索結果がなければ、現在地をCameraPositionにする
                  initialCameraPosition: CameraPosition(
                    target: cameraPosition,
                    zoom: zoomLevel,
                  ),
                  markers: {
                    (pinLocationIcon == null)
                        ? Marker(
                            markerId: (MarkerId('marker1')),
                            position: _initialPosition,
                          )
                        : Marker(
                            markerId: (MarkerId('marker1')),
                            position: _initialPosition,
                            icon: pinLocationIcon!),
                    if (searchedTarget != null)
                      Marker(
                        markerId: (MarkerId('marker2')),
                        position: LatLng(
                            searchedTarget?.geometry?.location?.lat as double,
                            searchedTarget?.geometry?.location?.lng as double),
                        infoWindow: InfoWindow(
                            title: searchedTarget?.name,
                            snippet: searchedTarget?.vicinity),
                      )
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: false,
                  buildingsEnabled: true,
                  scrollGesturesEnabled: true,
                  onTap: (LatLng latLang) {
                    print('Clicked: $latLang');
                  },
                ),
                ...zoomGuidLine(screenWidth, screenHeight),
                Text("Zoom Level: $zoomLevel"),
                if (isSearching)
                  Container(
                      height: MediaQuery.of(context).size.height * 1.0,
                      width: MediaQuery.of(context).size.width * 1.0,
                      padding: EdgeInsets.only(top: 80),
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: nearByPredictions?.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text("${nearByPredictions?[index].name}"),
                              subtitle: Text(
                                  nearByPredictions?[index].vicinity as String),
                              trailing:
                                  Text("⭐️${nearByPredictions?[index].rating}"),
                              onTap: () async {
                                searchedTarget = nearByPredictions![index];
                                zoomLevel = zoomLevelSearchDone;
                                setState(() {
                                  isSearching = false;
                                });
                                cameraPosition = LatLng(
                                    searchedTarget?.geometry?.location?.lat
                                        as double,
                                    searchedTarget?.geometry?.location?.lng
                                        as double);
                                _changePosition(
                                    cameraPosition, zoomLevelSearchDone);
                              },
                            ),
                          );
                        },
                      )),
                if (searchedTarget != null)
                  Positioned(
                      bottom: 10,
                      left: MediaQuery.of(context).size.width * 0.02,
                      child: TargetPlaceCard(searchedTarget: searchedTarget!)),
                // アイコン
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.05 + 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext newContext) {
                            return AccountInfoModal();
                          });
                    },
                    child: Container(
                      padding: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://github.com/katoatsushi.png',
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.05 + 10,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              spreadRadius: 1.0,
                              offset: Offset(10, 10))
                        ],
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width *
                                  (1.0 - 0.05 * 2) -
                              60,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                            onTap: () => {
                              setState(() {
                                isSearching = true;
                              })
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                searchNearByPlace(value);
                              } else {
                                setState(() {
                                  nearByPredictions = [];
                                });
                              }
                            },
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                color: Colors.grey[500],
                                icon: Icon(Icons.arrow_back_ios_new),
                                onPressed: () {
                                  setState(() {
                                    isSearching = false;
                                  });
                                },
                              ),
                              hintText: '場所を検索',
                              hintStyle: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              border: InputBorder.none,
                            ),
                          ))),
                ),
              ],
            ),
      // ),
    );
  }
}
