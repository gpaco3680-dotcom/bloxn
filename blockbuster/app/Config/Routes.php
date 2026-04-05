<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

// --- RUTAS PÚBLICAS (Punto 2.9 del PDF) ---
$routes->get('/', 'Home::index');
$routes->get('login', 'Auth::loginView');
$routes->post('auth/login', 'Auth::login');
$routes->get('register', 'Auth::registerView');
$routes->post('auth/register', 'Auth::register');
$routes->get('auth/logout', 'Auth::logout');

// --- GRUPO ADMINISTRADOR (Punto 5.1 - 5.4 del PDF) ---
$routes->group('admin', ['filter' => 'AdminFilter'], function($routes) {
    // Dashboard principal (Resuelve el 404 tras el login)
    $routes->get('/', 'Admin\Dashboard::index'); 
    
    // CRUDs Elementales (Punto 10.1 - 10.7 del PDF)
    $routes->resource('usuarios', ['controller' => 'Admin\Usuarios']);
    $routes->resource('generos', ['controller' => 'Admin\Generos']);
    $routes->resource('planes', ['controller' => 'Admin\Planes']);
    $routes->resource('streaming', ['controller' => 'Admin\Streaming']);

    // Change password
    $routes->get('change-password', 'Auth::changePasswordView');
    $routes->post('change-password', 'Auth::changePassword');
});

// --- GRUPO OPERADOR (Punto 6.1 - 6.2 del PDF) ---
$routes->group('operador', ['filter' => 'OperadorFilter'], function($routes) {
    // Dashboard principal (Resuelve el 404 tras el login)
    $routes->get('/', 'Operador\Clientes::index'); 
    
    // Validación de Clientes y Pagos (Puntos 65 y 66 del PDF)
    $routes->get('clientes', 'Operador\Clientes::index');
    $routes->get('clientes/aprobar/(:num)', 'Operador\Clientes::aprobar/$1');
    $routes->get('clientes/rechazar/(:num)', 'Operador\Clientes::rechazar/$1');

    $routes->get('pagos', 'Operador\ValidacionPagos::index');
    $routes->post('pagos/aprobar/(:num)', 'Operador\ValidacionPagos::aprobar/$1');
    $routes->get('pagos/rechazar/(:num)', 'Operador\ValidacionPagos::rechazar/$1');

    // Change password
    $routes->get('change-password', 'Auth::changePasswordView');
    $routes->post('change-password', 'Auth::changePassword');
});

// --- GRUPO CLIENTE (Punto 7.1 - 7.3 del PDF) ---
$routes->group('cliente', ['filter' => 'ClienteFilter'], function($routes) {
    // Dashboard principal (Resuelve el 404 tras el login)
    $routes->get('/', 'Cliente\Catalogo::index'); 
    
    // Catálogo y Alquiler (Punto 40 y 41 del PDF)
    $routes->get('catalogo', 'Cliente\Catalogo::index');
    $routes->get('catalogo/detalle/(:num)', 'Cliente\Catalogo::detalle/$1');
    $routes->get('alquiler/rentar/(:num)', 'Cliente\Alquiler::rentar/$1');
    
    // Perfil y Pagos (Punto 54 y 84 del PDF)
    $routes->get('perfil', 'Cliente\Perfil::index');
    $routes->post('pagar', 'Cliente\Perfil::generarPago'); // Simulación requerida

    // Change password
    $routes->get('change-password', 'Auth::changePasswordView');
    $routes->post('change-password', 'Auth::changePassword');
});