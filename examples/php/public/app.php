<?php
require_once __DIR__ . '/../vendor/autoload.php';

use ByJG\RestServer\Route\RouteList;
use ByJG\RestServer\Route\Route;
use ByJG\RestServer\HttpRequestHandler;
use ByJG\RestServer\OutputProcessor\JsonOutputProcessor;

$routeDefinition = new RouteList();
$routeDefinition->addRoute(Route::get("/test")
    ->withOutputProcessor(JsonOutputProcessor::class)
    ->withClosure(function ($response, $request) {
        $response->write('OK');
    })
);

$restServer = new HttpRequestHandler();
$restServer->handle($routeDefinition);