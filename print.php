<?php

require_once('config.inc.php');
require_once('db.php');

function goPrint( $config, $filename_print )
{
    $printimage = shell_exec(
        sprintf(
            $config['print']['cmd'],
            $filename_print
        )
    ); 

    return $printimage;
}

$filename = trim(basename($_GET['filename']));
if($pos = strpos($filename, '?')) {
    $parts = explode('?', $filename);
    $filename = array_shift($parts);
}

$filename_source = $config['folders']['images'] . DIRECTORY_SEPARATOR . $filename;
$filename_print = $config['folders']['print'] . DIRECTORY_SEPARATOR . $filename;
$filename_codes = $config['folders']['qrcodes'] . DIRECTORY_SEPARATOR . $filename;
$filename_thumb = $config['folders']['thumbs'] . DIRECTORY_SEPARATOR . $filename;
$status = false;

// print
if(file_exists($filename_source)) {
    // copy and merge
    if(!file_exists($filename_print)) 
    {
        // create qr code
        if(!file_exists($filename_codes)) {
            include('resources/lib/phpqrcode/qrlib.php');
            $url = 'http://'.$_SERVER['HTTP_HOST'].'/download.php?image=';
            QRcode::png($url.$filename, $filename_codes, QR_ECLEVEL_H, 10);
        }

        // merge source and code
        list($width, $height) = getimagesize($filename_source);
        $newwidth = $width + ($height / 2);
        $newheight = $height;

        $source = imagecreatefromjpeg($filename_source);
        $code = imagecreatefrompng($filename_codes);
        $print = imagecreatetruecolor($newwidth, $newheight);

        imagefill($print, 0, 0, imagecolorallocate($print, 255, 255, 255));
        imagecopy($print, $source , 0, 0, 0, 0, $width, $height);
        imagecopyresized($print, $code, $width, 0, 0, 0, ($height / 2), ($height / 2), imagesx($code), imagesy($code));

        imagejpeg($print, $filename_print);
        imagedestroy($print);        
        imagedestroy($code);
        imagedestroy($source);
    }

    if($config['print']['allow']) 
    {
        if( isset( $_GET['print_code'] ) ) 
        {
            $printCode = trim( $_GET['print_code'] );

            if( file_exists( $printCodeDB = 'printCodeDB.txt' ) )
            {
                $codeValue = json_decode( file_get_contents( $printCodeDB ), true );

                if( array_key_exists( $printCode, $codeValue ) )
                {
                    if( $codeValue[$printCode] >= (int)$config['print']['nb'])
                    {
                        $status = 'nOk';
                        $msg = 'You use your print quota!';
                    }
                    else
                    {
                        $status = goPrint( $config, $filename_print );
                        $codeValue[$printCode] = $codeValue[$printCode] + 1;

                        $codeValue = json_encode( $codeValue );
                        file_put_contents( $printCodeDB,  $codeValue );
                    }
                }
                else
                {
                    $status = 'nOk';
                    $msg = 'You code is unknow!';                    
                }
            }
            else
            {
                $status = 'nOk';
                $msg = 'No printCodeDB file !';
            }                
        }
        else
        {
            $status = 'nOk';
            $msg = 'Print code is mandatory';            
        }      
    }  
    else
    {
        $status = goPrint( $config, $filename_print );
    }


} else {
    $status = sprintf('file "%s" not found', $filename_source);
}

echo json_encode(array('status' => $status, 'msg' => $msg));
exit;
