<?php namespace App\Models;
use CodeIgniter\Model;

class UsuarioModel extends Model {
    protected $table      = 'usuarios';
    protected $primaryKey = 'id_usuario';
    protected $allowedFields = [
        'nombre_usuario', 'ap_usuario', 'am_usuario', 
        'email_usuario', 'password_usuario', 'id_rol', 'estatus_usuario'
    ];

    // Función para validar el login según el PDF (estatus activo)
    public function validarUsuario($email) {
        return $this->where('email_usuario', $email)
                    ->where('estatus_usuario', 'activo')
                    ->first();
    }
}