import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestMapPage extends StatefulWidget {
  const TestMapPage({super.key});

  @override
  State<TestMapPage> createState() => _TestMapPageState();
}

class _TestMapPageState extends State<TestMapPage> {
  // Gunakan koordinat yang diminta: -7.3881440220516, 109.3478756561706
  final LatLng _center = const LatLng(-7.3881440220516, 109.3478756561706);
  int _currentIndex = 0;

  // Marker untuk menandai lokasi
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Tambahkan marker pada koordinat tersebut
    _addMarker();
  }

  void _addMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('target_location'),
        position: _center,
        infoWindow: const InfoWindow(
          title: 'Lokasi Target',
          snippet: '-7.3881440220516, 109.3478756561706',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Google Maps'),
      ),
      body: _currentIndex == 0 
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                // Optional: Anda bisa melakukan sesuatu setelah map dibuat
              },
            )
          : _buildOtherPages(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Peta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildOtherPages() {
    switch (_currentIndex) {
      case 1:
        return const Center(child: Text('Halaman Pencarian'));
      case 2:
        return const Center(child: Text('Halaman Profil'));
      default:
        return const Center(child: Text('Halaman Tidak Diketahui'));
    }
  }
}