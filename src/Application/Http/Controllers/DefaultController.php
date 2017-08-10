<?php

namespace Application\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;

class DefaultController extends BaseController
{
    public function getAll()
    {
        return 'default controller getAll';
    }

    public function getOne($id)
    {
        return "default controller getOne $id";
    }

    public function insert()
    {
        return 'default controller insert';
    }

    public function update($id)
    {
        return "default controller update $id";
    }

    public function delete($id)
    {
        return "default controller delete $id";
    }
}
