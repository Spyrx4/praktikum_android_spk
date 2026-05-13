<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('smartphones', function (Blueprint $table) {
            $table->id();
            $table->string('nama_hp');
            $table->float('harga'); // kriteria 1 (cost)
            $table->float('ram'); // kriteria 2 (benefit)
            $table->float('kamera'); // kriteria 3 (benefit)
            $table->float('baterai'); // kriteria 4 (benefit)
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('smartphones');
    }
};
