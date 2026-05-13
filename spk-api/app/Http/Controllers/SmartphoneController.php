<?php

namespace App\Http\Controllers;

use App\Models\Smartphone;
use App\Models\vikor_results;
use Illuminate\Http\Request;
use App\Models\wp_results;  

class SmartphoneController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(Smartphone::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'nama_hp' => 'required|string',
            'harga' => 'required|numeric',
            'ram' => 'required|numeric',
            'kamera' => 'required|numeric',
            'baterai' => 'required|numeric'
        ]);
        return Smartphone::create($data);
    }

    /**
     * Display the specified resource.
     */
    public function show(Smartphone $smartphone)
    {
        return $smartphone;
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Smartphone $smartphone)
    {
        $smartphone->update($request->all());
        return $smartphone;
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Smartphone $smartphone)
    {
        $smartphone->delete();
        return response()->json(['message' => 'berhasil dihapus']);
    }

    public function hitungDanSimpanVikor()
    {
        $data = Smartphone::all();
        if ($data->isEmpty()) return response()->json(['message' => 'Data kosong'], 404);

        $w = [0.4, 0.25, 0.2, 0.15]; // Bobot

        // 1. Cari f* (Terbaik) dan f- (Terburuk)
        $fStar = ['harga' => $data->min('harga'), 'ram' => $data->max('ram'), 'kamera' => $data->max('kamera'), 'baterai' => $data->max('baterai')];
        $fMin = ['harga' => $data->max('harga'), 'ram' => $data->min('ram'), 'kamera' => $data->min('kamera'), 'baterai' => $data->min('baterai')];

        $listS = []; $listR = []; $tempResults = [];

        // 2. Hitung S dan R
        foreach ($data as $hp) {
            $sHarga = 0.4 * ($hp->harga - $fStar['harga']) / (max($fMin['harga'] - $fStar['harga'], 1));
            $sRam = 0.25 * ($fStar['ram'] - $hp->ram) / (max($fStar['ram'] - $fMin['ram'], 1));
            $sKamera = 0.2 * ($fStar['kamera'] - $hp->kamera) / (max($fStar['kamera'] - $fMin['kamera'], 1));
            $sBaterai = 0.15 * ($fStar['baterai'] - $hp->baterai) / (max($fStar['baterai'] - $fMin['baterai'], 1));

            $sTotal = $sHarga + $sRam + $sKamera + $sBaterai;
            $rMax = max($sHarga, $sRam, $sKamera, $sBaterai);

            $tempResults[] = ['id' => $hp->id, 'nama' => $hp->nama_hp, 's' => $sTotal, 'r' => $rMax];
            $listS[] = $sTotal; $listR[] = $rMax;
        }

        // 3. Hitung Q
        $sStar = min($listS); $sMin = max($listS);
        $rStar = min($listR); $rMin = max($listR);

        foreach ($tempResults as &$res) {
            $res['q'] = 0.5 * ($res['s'] - $sStar) / (max($sMin - $sStar, 0.0001)) +
                        0.5 * ($res['r'] - $rStar) / (max($rMin - $rStar, 0.0001));
        }

        // ... bagian perhitungan S, R, Q ...

        // 1. Urutkan dulu datanya berdasarkan Q (terkecil ke terbesar)
        usort($tempResults, fn($a, $b) => $a['q'] <=> $b['q']);

        // 2. Kosongkan tabel hasil lama
        \DB::table('vikor_results')->truncate();

        // 3. Loop untuk simpan dan BERI NILAI RANKING ke array response
        foreach ($tempResults as $index => &$res) { // Tambahkan tanda & di depan $res
            $rank = $index + 1;

            // Simpan ke database
            \DB::table('vikor_results')->insert([
                'smartphone_id' => $res['id'],
                'nilai_s' => $res['s'],
                'nilai_r' => $res['r'],
                'nilai_q' => $res['q'],
                'ranking' => $rank,
                'created_at' => now(),
            ]);

            $res['ranking'] = $rank;
        }

        // 4. Return data yang sudah ada field 'ranking'-nya
        return response()->json($tempResults);
    }
    public function hitungDanSimpanWP(){
        $data = Smartphone::all();
        if ($data->isEmpty()) return response()->json(['message'=>'Data kosong'],404);

        $w = [
            'harga' => -0.4,
            'ram' => 0.25,
            'kamera' => 0.2,
            'baterai' => 0.15
        ];

        $totalS = 0;
        $tempResults = [];

        // Kosongkan tabel hasil lama
        \DB::table('wp_results')->truncate();

        foreach ($data as $item){
            $s = pow($item->harga, $w['harga'])*pow($item->ram, $w['ram'])*pow($item->kamera, $w['kamera'])*pow($item->baterai, $w['baterai']);
            $tempResults[] = ['id'=>$item->id, 'nama'=> $item->nama_hp, 's'=> $s];
            $totalS += $s;
        }

        if ($totalS > 0) {
            foreach($tempResults as &$res){
                $res['v'] = $res['s']/$totalS;
            }
        }

        usort($tempResults, fn($a, $b)=> $b['v']<=>$a['v']);

        foreach($tempResults as $key=>&$res){
            $rank = $key+1;
            \DB::table('wp_results')->insert([
                'smartphone_id' => $res['id'],
                'nilai_s' => $res['s'],
                'nilai_v' => $res['v'],
                'ranking' => $rank,
                'created_at' => now(),
            ]);
            $res['ranking'] = $rank;
        }
        return response()->json($tempResults);
    }

    public function bandingkanMetode() {
        $wp = \DB::table('wp_results')
            ->join('smartphones', 'wp_results.smartphone_id', '=', 'smartphones.id')
            ->select('smartphones.nama_hp', 'wp_results.ranking as rank_wp')
            ->get();

        $vikor = \DB::table('vikor_results')
            ->select('smartphone_id', 'ranking as rank_vikor')
            ->get();

        $perbandingan = [];
        $totalD2 = 0; // Untuk hitung Spearman
        $n = count($wp);

        foreach ($wp as $w) {
            // Cari ranking vikor untuk hp yang sama
            $v = \DB::table('vikor_results')
                ->where('smartphone_id', 
                    \DB::table('smartphones')->where('nama_hp', $w->nama_hp)->value('id')
                )->first();

            $d = $w->rank_wp - $v->ranking; // Selisih peringkat (di)
            $d2 = pow($d, 2); // d kuadrat
            $totalD2 += $d2;

            $perbandingan[] = [
                'nama' => $w->nama_hp,
                'wp' => $w->rank_wp,
                'vikor' => $v->ranking,
                'selisih' => abs($d),
            ];
        }

        // Rumus Spearman: 1 - (6 * sum(d^2) / (n * (n^2 - 1)))
        $koefisien = ($n > 1) ? 1 - ((6 * $totalD2) / ($n * (pow($n, 2) - 1))) : 1;

        return response()->json([
            'data' => $perbandingan,
            'koefisien' => $koefisien,
            'kategori' => $this->kategoriSpearman($koefisien),
        ]);
    }

    private function kategoriSpearman($k) {
        if ($k >= 0.8) return "Sangat Kuat (Konsisten)";
        if ($k >= 0.6) return "Kuat";
        if ($k >= 0.4) return "Cukup";
        return "Lemah (Hasil Berbeda Jauh)";
    }

    public function getVikorRanking() {
        $ranking = \DB::table('vikor_results')
            ->join('smartphones', 'vikor_results.smartphone_id', '=', 'smartphones.id')
            ->select('smartphones.nama_hp', 'vikor_results.nilai_q as skor', 'vikor_results.ranking')
            ->orderBy('vikor_results.ranking', 'asc')
            ->get();
        return response()->json($ranking);
    }

    public function getWpRanking() {
        $ranking = \DB::table('wp_results')
            ->join('smartphones', 'wp_results.smartphone_id', '=', 'smartphones.id')
            ->select('smartphones.nama_hp', 'wp_results.nilai_v as skor', 'wp_results.ranking')
            ->orderBy('wp_results.ranking', 'asc')
            ->get();
        return response()->json($ranking);
    }
}


