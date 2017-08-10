<?php

namespace Application\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;

class DefaultController extends BaseController
{
    public function getAll()
    {
        return '<br>default controller getall';
    }

    public function getOne()
    {
        return '<br>default controller getOne';
    }

    public function insert()
    {
        return '<br>default controller insert';
    }

    public function update()
    {
        return '<br>default controller update';
    }

    public function delete()
    {
        return '<br>default controller delete';

    }
}
