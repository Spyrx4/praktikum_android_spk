<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SmartphoneController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/spk/vikor-proses', [SmartphoneController::class, 'hitungDanSimpanVikor']);
Route::get('/spk/wp-proses', [SmartphoneController::class, 'hitungDanSimpanWP']);
Route::get('/spk/perbandingan', [SmartphoneController::class, 'bandingkanMetode']);
Route::get('/spk/vikor-ranking', [SmartphoneController::class, 'getVikorRanking']);
Route::get('/spk/wp-ranking', [SmartphoneController::class, 'getWpRanking']);
Route::apiResource('smartphones', SmartphoneController::class);