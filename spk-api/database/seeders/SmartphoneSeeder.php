<?php

namespace Database\Seeders;

use App\Models\Smartphone;
use Illuminate\Database\Seeder;

class SmartphoneSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \Schema::disableForeignKeyConstraints();
        \DB::table('vikor_results')->truncate();
        \DB::table('wp_results')->truncate();
        Smartphone::truncate();
        \Schema::enableForeignKeyConstraints();

        $data = [
            [
                'nama_hp' => 'iPhone 15 Pro',
                'harga' => 20000000,
                'ram' => 8,
                'kamera' => 48,
                'baterai' => 3274,
            ],
            [
                'nama_hp' => 'Samsung Galaxy S24 Ultra',
                'harga' => 22000000,
                'ram' => 12,
                'kamera' => 200,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Xiaomi 14',
                'harga' => 12000000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 4610,
            ],
            [
                'nama_hp' => 'Google Pixel 8',
                'harga' => 11000000,
                'ram' => 8,
                'kamera' => 50,
                'baterai' => 4575,
            ],
            [
                'nama_hp' => 'Oppo Find X7 Ultra',
                'harga' => 14000000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Vivo X100 Pro',
                'harga' => 13500000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 5400,
            ],
            [
                'nama_hp' => 'Realme GT5 Pro',
                'harga' => 9000000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 5400,
            ],
            [
                'nama_hp' => 'Asus ROG Phone 8',
                'harga' => 18000000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 5500,
            ],
            [
                'nama_hp' => 'Sony Xperia 1 V',
                'harga' => 19000000,
                'ram' => 12,
                'kamera' => 48,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Nothing Phone 2',
                'harga' => 9500000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 4700,
            ],
            // 10 New Smartphone Entries
            [
                'nama_hp' => 'Samsung Galaxy A55',
                'harga' => 6000000,
                'ram' => 8,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Xiaomi Redmi Note 13 Pro',
                'harga' => 4500000,
                'ram' => 8,
                'kamera' => 200,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Infinix GT 20 Pro',
                'harga' => 4000000,
                'ram' => 12,
                'kamera' => 108,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'POCO X6 Pro',
                'harga' => 5000000,
                'ram' => 12,
                'kamera' => 64,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'iQOO 12 5G',
                'harga' => 11000000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Nubia RedMagic 9 Pro',
                'harga' => 13000000,
                'ram' => 16,
                'kamera' => 50,
                'baterai' => 6500,
            ],
            [
                'nama_hp' => 'OnePlus 12R',
                'harga' => 9000000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 5500,
            ],
            [
                'nama_hp' => 'Vivo V30 Pro',
                'harga' => 8000000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 5000,
            ],
            [
                'nama_hp' => 'Oppo Reno 11 Pro',
                'harga' => 7500000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 4600,
            ],
            [
                'nama_hp' => 'TECNO Camon 30 Premier',
                'harga' => 6500000,
                'ram' => 12,
                'kamera' => 50,
                'baterai' => 5000,
            ],
        ];

        foreach ($data as $item) {
            Smartphone::create($item);
        }
    }
}
