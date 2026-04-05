<?php namespace App\Models;

use CodeIgniter\Model;

class StreamingModel extends Model {
    protected $table = 'blockbuster_streaming';
    protected $primaryKey = 'id_streaming';

    // Lista extendida para cumplir con los puntos 15 y 119 del PDF
    protected $allowedFields = [
        'nombre_streaming', 
        'estatus_streaming', 
        'duracion_streaming', 
        'temporadas_streaming', 
        'caratula_streaming', 
        'trailer_streaming',       // Requerido por el PDF
        'clasificacion_streaming', 
        'sipnosis_streaming',      // Requerido para "Detalles"
        'fecha_estreno_streaming', // Requerido para "Recién agregados"
        'id_genero'
    ];

    /**
     * Obtiene el catálogo con el nombre del género (JOIN)
     * Requisito para el punto 34 (Tipos Géneros) del PDF
     */
    public function getCatalogoConGenero() {
        return $this->select('blockbuster_streaming.*, generos.nombre_genero')
                    ->join('generos', 'generos.id_genero = blockbuster_streaming.id_genero')
                    ->where('blockbuster_streaming.estatus_streaming', 1) // Solo habilitados (Punto 15)
                    ->findAll();
    }

    public function getPorIdConGenero($id) {
        return $this->select('blockbuster_streaming.*, generos.nombre_genero')
                    ->join('generos', 'generos.id_genero = blockbuster_streaming.id_genero')
                    ->where('blockbuster_streaming.id_streaming', $id)
                    ->first();
    }
}