import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// 🎨 Palet warna konsisten dengan halaman lain
const Color softLavender = Color(0xFFE0BBE4);
const Color palePink = Color(0xFFFFD1DC);
const Color softBlue = Color.fromARGB(255, 113, 196, 255);
const Color deepContrast = Color(0xFF4A4E69);
const Color accentButton = Color(0xFF957DAD);
const Color whiteContrast = Color(0xFFFDFDFD);

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final MapController _mapController;
  LatLng? _currentPosition;
  bool _loading = true;
  String? _error;

  final List<Map<String, dynamic>> _disneyLocations = [
    {'name': 'Disneyland California', 'lat': 33.8121, 'lon': -117.9190},
    {'name': 'Walt Disney World Florida', 'lat': 28.3852, 'lon': -81.5639},
    {'name': 'Tokyo Disneyland', 'lat': 35.6329, 'lon': 139.8804},
    {'name': 'Disneyland Paris', 'lat': 48.8674, 'lon': 2.7833},
    {'name': 'Hong Kong Disneyland', 'lat': 22.3129, 'lon': 114.0419},
    {'name': 'Shanghai Disney Resort', 'lat': 31.1434, 'lon': 121.6589},
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Layanan lokasi tidak aktif. Aktifkan GPS di pengaturan.';
          _loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Izin lokasi ditolak.';
            _loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error =
              'Izin lokasi ditolak permanen. Aktifkan dari pengaturan perangkat.';
          _loading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal mendapatkan lokasi: $e';
        _loading = false;
      });
    }
  }

  double _distanceTo(double lat, double lon) {
    if (_currentPosition == null) return 0;
    return Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          lat,
          lon,
        ) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: accentButton),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Peta Disney World 🌍'),
          backgroundColor: accentButton,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _determinePosition,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentButton,
                  ),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_currentPosition == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Peta Disney World 🌍'),
          backgroundColor: accentButton,
        ),
        body: const Center(
          child: Text('Lokasi tidak tersedia 😅'),
        ),
      );
    }

    final locationsWithDistance = _disneyLocations
        .map((loc) => {
              'name': loc['name'],
              'lat': loc['lat'],
              'lon': loc['lon'],
              'distance': _distanceTo(loc['lat'], loc['lon']),
            })
        .toList()
      ..sort((a, b) =>
          (a['distance'] as double).compareTo(b['distance'] as double));

    final nearest = locationsWithDistance.first;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Peta Disney World 🌍'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 🗺️ MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition!,
              initialZoom: 3.5,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'disney_nina',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 60,
                    height: 60,
                    child: const Icon(Icons.my_location,
                        color: Colors.blueAccent, size: 35),
                  ),
                  ..._disneyLocations.map((d) {
                    final dist = _distanceTo(d['lat'], d['lon']);
                    return Marker(
                      point: LatLng(d['lat'], d['lon']),
                      width: 80,
                      height: 80,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: whiteContrast,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: Text(
                                d['name'],
                                style: const TextStyle(
                                    color: deepContrast,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                  'Jarak dari lokasi kamu: ${dist.toStringAsFixed(1)} km'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Tutup',
                                    style: TextStyle(color: accentButton),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Icon(Icons.location_on,
                            color: Colors.redAccent, size: 35),
                      ),
                    );
                  })
                ],
              ),
            ],
          ),

          // 🩵 INFO PANEL melayang
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [softLavender, palePink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: deepContrast.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "🌟 Disneyland Terdekat 🌟",
                    style: TextStyle(
                      color: deepContrast,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    nearest['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: accentButton,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "${nearest['distance'].toStringAsFixed(1)} km dari kamu",
                    style: TextStyle(
                        color: deepContrast.withOpacity(0.7), fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: locationsWithDistance.length,
                      itemBuilder: (context, index) {
                        final loc = locationsWithDistance[index];
                        return GestureDetector(
                          onTap: () {
                            _mapController.move(
                                LatLng(loc['lat'], loc['lon']), 6.0);
                          },
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: whiteContrast.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: deepContrast.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  loc['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: deepContrast,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${loc['distance'].toStringAsFixed(1)} km",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          deepContrast.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🎯 Tombol lokasi saya (Floating Button)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPosition != null) {
            _mapController.move(_currentPosition!, 10.0);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berpindah ke lokasi kamu 📍')),
            );
          } else {
            _determinePosition();
          }
        },
        backgroundColor: accentButton,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
