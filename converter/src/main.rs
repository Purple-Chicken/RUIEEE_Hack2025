extern crate image;

use std::env;
use std::path::Path;
use std::fmt;
use std::fs::File;
use image::GenericImageView;
use image::imageops::resize;
use image::ImageFormat;
use image::imageops::FilterType;
use image::codecs::bmp;
use image::ImageBuffer;
use image::GenericImage;
use image::DynamicImage;
use image::Rgba;
fn main() {
    let img = image::open("../pics/colorblind.jpg").unwrap();
    println!("Dimensions: {:?}",img.dimensions());
    //println!("Color type: {:?}",img.color_type());
    let out = img.resize(620,480,FilterType::Gaussian);
    println!("Dimensions of out: {:?}", out.dimensions());
    //println!("Color type: {:?}",out.color_type());
    let mut file = File::create("out.bmp").unwrap();
    let file = out.write_to(&mut file, ImageFormat::Bmp).unwrap();
    // Create new file w/ correct dimensions
    let mut out2 = image::ImageBuffer::from_pixel(620,480,Rgba([0,0,0,255]));

    for (x,y,pixel) in out.pixels() {
        out2.put_pixel(x+(620-out.dimensions().0)/2 , y + (480-out.dimensions().1)/2 , pixel);
    }
   DynamicImage::ImageRgba8(out2).save("out2.bmp").expect("Failed to center.")




}