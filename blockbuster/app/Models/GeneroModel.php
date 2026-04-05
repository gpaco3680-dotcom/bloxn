<?php namespace App\Models;
use CodeIgniter\Model;

class GeneroModel extends Model {
    protected $table = 'generos';
    protected $primaryKey = 'id_genero';
    protected $allowedFields = ['nombre_genero', 'descripcion_genero', 'estatus_genero'];
}