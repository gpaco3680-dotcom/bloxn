<?php namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

class OperadorFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $session = session();
        
        if (!$session->get('isLoggedIn')) {
            return redirect()->to('/login');
        }
        
        // Validar que el rol sea Operador (id_rol = 2)
        if ($session->get('rol') != 2) {
            return redirect()->to('/')->with('error', 'No tiene permisos para acceder a esta sección.');
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        //
    }
}
