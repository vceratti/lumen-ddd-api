<?php

namespace Application\Http\Controllers;

use Laravel\Lumen\Routing\Controller as BaseController;

/**
 * Class DefaultController
 * @package Application\Http\Controllers
 */
class DefaultController extends BaseController
{
    /**
     * @return string
     */
    public function getAll()
    {
        return 'default controller getAll';
    }

    /**
     * @SWG\Info(title="My First API", version="0.1")
     */

    /**
     * @SWG\Get(
     *     path="/api/resource.json",
     *     @SWG\Response(response="200", description="An example resource")
     * )
     */
    public function getOne($id)
    {
        return "default controller getOne $id";
    }

    /**
     * @return string
     */
    public function insert()
    {
        return 'default controller insert';
    }

    /**
     * @param $id
     * @return string
     */
    public function update($id)
    {
        return "default controller update $id";
    }

    /**
     * @param $id
     * @return string
     */
    public function delete($id)
    {
        return "default controller delete $id";
    }
}
