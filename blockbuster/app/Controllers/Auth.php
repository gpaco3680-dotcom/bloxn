<?php namespace App\Controllers;

use App\Models\UsuarioModel;

class Auth extends BaseController {
    public function login() {
    $session = session();
    $model = new UsuarioModel();
    
    // Captura de datos
    $email = $this->request->getVar('email');
    $password = $this->request->getVar('password');
    
    // Búsqueda usando el nombre de columna exacto del PDF 
    $user = $model->where('email_usuario', $email)->first();

    if($user && password_verify($password, $user['password_usuario'])) {
        
        // Verificación de estatus habilitado (Punto 2.2 del PDF) 
        // Ajustado a 'activo' según tus inserciones previas
        if($user['estatus_usuario'] == 'activo' || $user['estatus_usuario'] == 1) { 
            
            // Seteo de sesión con los campos requeridos
            $session->set([
                'id_usuario' => $user['id_usuario'], 
                'rol'        => $user['id_rol'], 
                'isLoggedIn' => true,
                'nombre'     => $user['nombre_usuario']
            ]);

            // Redirección a módulos específicos según requerimientos del PDF 
            if ($user['id_rol'] == 1) { // Administrador
                return redirect()->to('/admin'); 
            } elseif ($user['id_rol'] == 2) { // Operador
                return redirect()->to('/operador'); 
            } else { // Cliente
                return redirect()->to('/cliente/catalogo'); // Portal público 
            }
            
        } else {
            // Mensaje de error si el estatus no es habilitado 
            return redirect()->back()->with('error', 'Usuario deshabilitado. Contacte al administrador.');
        }
    }
    
    return redirect()->back()->with('error', 'Credenciales incorrectas.');
}

    public function register() {
        $model = new UsuarioModel();
        $data = [
            'nombre_usuario' => $this->request->getVar('nombre'),
            'ap_usuario' => $this->request->getVar('ap'),
            'am_usuario' => $this->request->getVar('am'),
            'email_usuario' => $this->request->getVar('email'),
            'password_usuario' => password_hash($this->request->getVar('password'), PASSWORD_DEFAULT),
            'id_rol' => 3, // Cliente
            'estatus_usuario' => 0, // Pendiente de aprobación
        ];
        $model->insert($data);
        return redirect()->to('/login')->with('success', 'Registro exitoso. Espera aprobación.');
    }

    public function loginView() {
        return view('Auth/login');
    }

    public function registerView() {
        return view('Auth/register');
    }

    public function logout() {
        session()->destroy();
        return redirect()->to('/login');
    }

    public function changePasswordView() {
        $session = session();
        $rol = $session->get('rol');
        if ($rol == 1) {
            return view('Admin/change_password');
        } elseif ($rol == 2) {
            return view('Operador/change_password');
        } else {
            return view('Cliente/change_password');
        }
    }

    public function changePassword() {
        $session = session();
        $model = new UsuarioModel();

        $currentPassword = $this->request->getVar('current_password');
        $newPassword = $this->request->getVar('new_password');
        $confirmPassword = $this->request->getVar('confirm_password');

        // Get current user
        $userId = $session->get('id_usuario');
        $user = $model->find($userId);

        if (!$user) {
            return redirect()->back()->with('error', 'Usuario no encontrado.');
        }

        // Verify current password
        if (!password_verify($currentPassword, $user['password_usuario'])) {
            return redirect()->back()->with('error', 'Contraseña actual incorrecta.');
        }

        // Check if new passwords match
        if ($newPassword !== $confirmPassword) {
            return redirect()->back()->with('error', 'Las nuevas contraseñas no coinciden.');
        }

        // Validate new password strength (optional, but good practice)
        if (strlen($newPassword) < 6) {
            return redirect()->back()->with('error', 'La nueva contraseña debe tener al menos 6 caracteres.');
        }

        // Hash new password and update
        $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
        $model->update($userId, ['password_usuario' => $hashedPassword]);

        return redirect()->back()->with('success', 'Contraseña cambiada exitosamente.');
    }
}