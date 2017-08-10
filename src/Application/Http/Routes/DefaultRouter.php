<?php

namespace Application\Http\Routes;

class DefaultRouter
{
    private $urlMap;
    private $app;

    public function __construct($app)
    {
        $this->app = $app;
        $this->configRouterMap();
    }

    public function configRouterMap()
    {
        $this->setMethod('getAll', 'get');
        $this->setMethod('insert', 'post');
        $this->setMethodRequiringId('getOne', 'get');
        $this->setMethodRequiringId('update', 'put');
        $this->setMethodRequiringId('delete', 'delete');

    }

    public function setMethod($function, $method)
    {
        $this->urlMap[$function]['method'] = $method;
    }

    public function setMethodRequiringId($function, $method)
    {
        $this->setMethod($function, $method);
        $this->urlMap[$function]['id'] = true;
    }

    /**
     * @param $routes array $routes[ 'url' ] => [ 'Controller' => [ 'method', ... ]
     */
    public function addRoutes($routes)
    {
        foreach ($routes as $url => $controller) {
            foreach ($controller as $class => $action) {
                foreach ($action as $method) {
                    $restUrl = $this->makeUrl($method, $url);
                    $apiMethod = $this->mapMethod($method);
                    $this->app->$apiMethod($restUrl, "{$class}Controller@$method");
                }
            }
        }
    }

    public function makeUrl($method, $url)
    {
        $url = "/$url";

        if (isset($this->urlMap[$method]['id'])) {
            $url .= '/{id:[0-9]+}';
        }

        return $url;
    }

    public function mapMethod($method)
    {
        return $this->urlMap[$method]['method'];
    }
}
