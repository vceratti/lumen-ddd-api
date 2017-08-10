<?php

use Laravel\Lumen\Testing\DatabaseMigrations;
use Laravel\Lumen\Testing\DatabaseTransactions;

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
        $this->get('/user/1');
        $this->assertEquals($this->app->version(), $this->response->getContent());
    }
}
