<?php

namespace Tests\Http;

use Tests\TestCase;

class RouteTest extends TestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function testExample()
    {
        $this->get('/');
        $this->assertEquals($this->app->version(), $this->response->getContent());
    }

    /** User routes  */
    public function testUserRoutes()
    {
        $this->get('/users');
        $this->assertEquals('default controller getAll', $this->response->getContent());
        $this->get('/users/1');
        $this->assertEquals('default controller getOne 1', $this->response->getContent());
        $this->post('/users');
        $this->assertEquals('default controller insert', $this->response->getContent());
        $this->put('/users/2');
        $this->assertEquals('default controller update 2', $this->response->getContent());
        $this->delete('/users/3');
        $this->assertEquals('default controller delete 3', $this->response->getContent());
    }
}
