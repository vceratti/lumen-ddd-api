<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$app->get('/', function () use ($app) {
    return $app->version();
});

$router = new \Application\Http\Routes\DefaultRouter($app);

$app->group(['namespace' => 'User'], function () use ($router) {
    $routes['users'] = ['User' => ['getAll', 'getOne', 'insert', 'update', 'delete']];
    $router->addRoutes($routes);
});
