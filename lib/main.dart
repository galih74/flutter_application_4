import 'package:flutter/material.dart';

void main() {
  runApp(const WisataApp());
}

class WisataItem {
  final String name;
  final String location;
  final String description;
  final String price;
  final String rating;
  final String imageAsset;

  const WisataItem({
    required this.name,
    required this.location,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageAsset,
  });
}

class WisataApp extends StatefulWidget {
  const WisataApp({super.key});

  @override
  State<WisataApp> createState() => _WisataAppState();
}

class _WisataAppState extends State<WisataApp> {
  // Daftar global untuk menyimpan destinasi yang difavoritkan
  final List<WisataItem> _favoriteList = [];

  void _toggleFavorite(WisataItem item) {
    setState(() {
      if (_favoriteList.any((fav) => fav.name == item.name)) {
        _favoriteList.removeWhere((fav) => fav.name == item.name);
      } else {
        _favoriteList.add(item);
      }
    });
  }

  bool _isFavorite(WisataItem item) {
    return _favoriteList.any((fav) => fav.name == item.name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisata Bali',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF4F9F9),
      ),
      home: LoginScreen(
        favoriteList: _favoriteList,
        onToggleFavorite: _toggleFavorite,
        isFavorite: _isFavorite,
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final List<WisataItem> favoriteList;
  final Function(WisataItem) onToggleFavorite;
  final bool Function(WisataItem) isFavorite;

  const LoginScreen({
    super.key,
    required this.favoriteList,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            favoriteList: widget.favoriteList,
            onToggleFavorite: widget.onToggleFavorite,
            isFavorite: widget.isFavorite,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.travel_explore,
                  size: 80,
                  color: Colors.teal[800],
                ),
                const SizedBox(height: 16),
                Text(
                  'Wisata Bali',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Silakan masuk untuk melanjutkan',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username atau Email',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 4) {
                      return 'Password minimal 4 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _login,
                    child: const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<WisataItem> favoriteList;
  final Function(WisataItem) onToggleFavorite;
  final bool Function(WisataItem) isFavorite;

  const HomeScreen({
    super.key,
    required this.favoriteList,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisata Bali'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(
                    favoriteList: favoriteList,
                    onToggleFavorite: onToggleFavorite,
                    isFavorite: isFavorite,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/icon.jpg', 
                        fit: BoxFit.contain,
                        height: 180,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Selamat Datang, Traveler!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jelajahi keindahan Destinasi Wisata di Bali Terbaik dan Tersembunyi diseluruh Penjuru.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.explore),
                label: const Text('Lihat Daftar Wisata', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatalogScreen(
                        favoriteList: favoriteList,
                        onToggleFavorite: onToggleFavorite,
                        isFavorite: isFavorite,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.tips_and_updates),
                label: const Text('Tips & Panduan Wisata', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TipsScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal[800],
                  side: BorderSide(color: Colors.teal[800]!),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.person),
                label: const Text('Profil', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[500],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.favorite),
                label: const Text('Destinasi Favorit', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteScreen(
                        favoriteList: favoriteList,
                        onToggleFavorite: onToggleFavorite,
                        isFavorite: isFavorite,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CatalogScreen extends StatefulWidget {
  final List<WisataItem> favoriteList;
  final Function(WisataItem) onToggleFavorite;
  final bool Function(WisataItem) isFavorite;

  const CatalogScreen({
    super.key,
    required this.favoriteList,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final List<WisataItem> wisataList = const [
    WisataItem(
      name: 'Pura Tanah Lot',
      location: 'Desa Beraban, Kecamatan Kediri, Kabupaten Tabanan, Bali.',
      description: 'Destinasi wisata religi dan ikon budaya paling terkenal di Bali yang terletak di atas batu karang besar di lepas pantai Samudra Hindia.',
      price: 'Rp 30.000 / tiket',
      rating: '4.6',
      imageAsset: 'assets/images/tanahlot.png',
    ),
    WisataItem(
      name: 'Taman Budaya Garuda Wisnu Kencana (GWK)',
      location: 'Jl. Raya Uluwatu, Desa Ungasan, Kecamatan Kuta Selatan, Kabupaten Badung, Bali',
      description: 'Taman budaya sekaligus rumah bagi patung raksasa ikonik yang terletak di Ungasan, Kuta Selatan, Kabupaten Badung, Bali.',
      price: 'Rp 150.000 / tiket',
      rating: '5.0',
      imageAsset: 'assets/images/gwk.jpg',
    ),
    WisataItem(
      name: 'Pantai Kuta',
      location: 'Kecamatan Kuta, Kabupaten Badung, berjarak sekitar 1,5 km dari Bandara Internasional I Gusti Ngurah Rai.',
      price: 'Free',
      description: 'Pantai paling terkenal di Bali',
      rating: '4.7',
      imageAsset: 'assets/images/kuta.jpg',
    ),
    WisataItem(
      name: 'Pantai Pandawa',
      location: 'Desa Kutuh, Kecamatan Kuta Selatan, Kabupaten Badung, Bali.',
      description: 'Wisata populer',
      price: 'Rp 15.000 / tiket',
      rating: '4.7',
      imageAsset: 'assets/images/pandawa.jpeg',
    ),
    WisataItem(
      name: 'Pura Ulun Danu Beratan',
      location: 'Tepi barat Danau Beratan, Desa Candikuning, Kecamatan Baturiti, Kabupaten Tabanan',
      description: 'Sebuah pura dan candi air besar di Bali',
      price: 'Rp 50.000 / tiket',
      rating: '4.8',
      imageAsset: 'assets/images/purabedugul.jpg',
    ),
    WisataItem(
      name: 'Desa Penglipuran',
      location: 'Kelurahan Kubu, Kecamatan Bangli, Kabupaten Bangli, Bali.',
      description: 'Desa adat paling terkenal di Kabupaten Bangli, Bali, yang diakui sebagai salah satu desa terbersih di dunia.',
      price: 'Rp 25.000 / tiket',
      rating: '4.9',
      imageAsset: 'assets/images/desa.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Destinasi Wisata'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: wisataList.length,
        itemBuilder: (context, index) {
          final item = wisataList[index];
          final isFav = widget.isFavorite(item);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  item.imageAsset,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.teal),
                      const SizedBox(width: 4),
                      Expanded(child: Text(item.location, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
              // Tombol Love di List Catalog
              trailing: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    widget.onToggleFavorite(item);
                  });
                },
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      item: item,
                      onToggleFavorite: widget.onToggleFavorite,
                      isFavorite: widget.isFavorite,
                    ),
                  ),
                );
                setState(() {}); // Memperbarui tampilan saat kembali dari detail
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final WisataItem item;
  final Function(WisataItem) onToggleFavorite;
  final bool Function(WisataItem) isFavorite;

  const DetailScreen({
    super.key,
    required this.item,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isFav = widget.isFavorite(widget.item);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
        actions: [
          // Tombol Love di AppBar Halaman Detail
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                widget.onToggleFavorite(widget.item);
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              widget.item.imageAsset,
              height: 350,
              width: double.infinity,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        widget.item.price,
                        style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.map, size: 16, color: Colors.teal),
                      const SizedBox(width: 6),
                      Expanded(child: Text('Lokasi: ${widget.item.location}', style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic))),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(widget.item.rating, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Deskripsi Destinasi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.book_online),
                    label: const Text('Pesan Tiket Sekarang', style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(destinationName: widget.item.name),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.teal[800],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Kembali ke Daftar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingScreen extends StatefulWidget {
  final String destinationName;
  const BookingScreen({super.key, required this.destinationName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ticketController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ticketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pemesanan Tiket'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Destinasi Pilihan: ${widget.destinationName}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[900]),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap Pemesan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _ticketController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Tiket',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah tiket harus diisi';
                  }
                  final n = int.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Masukkan jumlah tiket yang valid (minimal 1)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Berhasil!'),
                          content: Text(
                            'Pemesanan ${_ticketController.text} tiket ke ${widget.destinationName} atas nama ${_nameController.text} telah dikonfirmasi.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); 
                                Navigator.pop(context); 
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Konfirmasi Pemesanan', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips & Panduan Wisata'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTipsCard(
            'Persiapan Dokumen',
            'Pastikan membawa identitas diri (KTP/Paspor) serta tiket perjalanan yang sudah dipesan secara digital.',
            Icons.document_scanner,
          ),
          const SizedBox(height: 12),
          _buildTipsCard(
            'Barang Bawaan',
            'Bawa pakaian yang nyaman sesuai kondisi destinasi, obat-obatan pribadi, serta pengisi daya (powerbank).',
            Icons.luggage,
          ),
          const SizedBox(height: 12),
          _buildTipsCard(
            'Jaga Kebersihan',
            'Selalu buang sampah pada tempatnya dan jaga kelestarian lingkungan tempat wisata yang dikunjungi.',
            Icons.eco,
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(String title, String desc, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: Colors.teal[700]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(desc, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                backgroundImage: AssetImage('assets/images/foto.jpeg'),
              ),
              const SizedBox(height: 16),
              const Text('Galih Kartika Sari', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('NPM: 25670090', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              const Text('Prodi Informatika - UPGRIS', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Aplikasi Katalog Informasi Wisata yang ada di Bali.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[800],
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  final List<WisataItem> favoriteList;
  final Function(WisataItem) onToggleFavorite;
  final bool Function(WisataItem) isFavorite;

  const FavoriteScreen({
    super.key,
    required this.favoriteList,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destinasi Favorit'),
        backgroundColor: Colors.teal[800],
        foregroundColor: Colors.white,
      ),
      body: widget.favoriteList.isEmpty
          ? const Center(
              child: Text('Belum ada destinasi favorit yang ditambahkan.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.favoriteList.length,
              itemBuilder: (context, index) {
                final item = widget.favoriteList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        item.imageAsset,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.price, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget.onToggleFavorite(item);
                        });
                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            item: item,
                            onToggleFavorite: widget.onToggleFavorite,
                            isFavorite: widget.isFavorite,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}