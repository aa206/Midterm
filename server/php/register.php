<?php

include_once("dbconnect.php");
$email = addslashes($_POST['email']);
$name = addslashes($_POST['name']);
$phoneno = $_POST['phoneno'];
$pass = sha1($password);
$password = $_POST['password'];
$homeaddress = $_POST['homeaddress'];
$base64image = $_POST['image'];

$sqlregister = "INSERT INTO registration (myt_email, myt_name, myt_phoneno, myt_password, myt_homeaddress) VALUES ('$email','$name','$phoneno','$password','$homeaddress')";

if ($conn->query($sqlregister) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = 'C:\Users\USER-2J\Documents\FlutterWS\mytutor\assets\profiles' . $filename . '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>