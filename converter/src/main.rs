extern crate image;

use std::fs::File;
use std::io::{Read, Write};
use image::GenericImageView;
use image::ImageFormat;
use image::imageops::FilterType;
use image::DynamicImage;
use image::Rgba;

fn main() {
    //let filename = "gradient.jpg" //File must be in pics
    let img = image::open("../pics/stonks.gif", ).unwrap();
    println!("Dimensions: {:?}",img.dimensions());
    //println!("Color type: {:?}",img.color_type());
    let out = img.resize(480,480,FilterType::Gaussian);
    println!("Dimensions of out: {:?}", out.dimensions());
    //println!("Color type: {:?}",out.color_type());
    let mut file = File::create("../pics/out.bmp").unwrap();
    let _file = out.write_to(&mut file, ImageFormat::Bmp).unwrap();
    // Create new file w/ correct dimensions
    let mut out2 = image::ImageBuffer::from_pixel(480,480,Rgba([0,0,0,255]));

    for (x,y,pixel) in out.pixels() {
        out2.put_pixel(x+(480-out.dimensions().0)/2 , y + (480-out.dimensions().1)/2 , pixel);
    }
    let _file2 = DynamicImage::ImageRgba8(out2).save("../pics/out2.bmp").expect("Failed to center.");
    

   reduce_color_depth_rgba("../pics/out2.bmp", "../pics/out3.bmp");
   bmp_to_coe("../pics/out2.bmp", "../out.coe")

}
fn reduce_color_depth_rgba(input_path: &str, output_path: &str) {
    // Open input BMP file
    let mut input_file = File::open(input_path).expect("Failed to open input BMP file");
    let mut bmp_data = Vec::new();
    input_file.read_to_end(&mut bmp_data).expect("Failed to read BMP file");

    // Validate BMP header
    if &bmp_data[0..2] != b"BM" {
        panic!("Not a valid BMP file");
    }

    // Offset to pixel data
    let pixel_array_offset = u32::from_le_bytes(bmp_data[10..14].try_into().unwrap()) as usize;

    // Process each pixel (RGBA format)
    let pixel_data = &mut bmp_data[pixel_array_offset..];
    for chunk in pixel_data.chunks_exact_mut(4) {
        chunk[0] = chunk[0] & 0xC0; // Top 2 bits of blue
        chunk[1] = chunk[1] & 0xE0; // Top 3 bits of green
        chunk[2] = chunk[2] & 0xE0; // Top 3 bits of red
        chunk[3] = chunk[3] & 0x00; // Top 0 bits of alpha
    }

    // Save the modified BMP
    let mut output_file = File::create(output_path).expect("Failed to create output BMP file");
    output_file.write_all(&bmp_data).expect("Failed to write BMP file");
}
fn bmp_to_coe(input_path: &str, coe_path: &str) {
    // Open BMP file
    let mut input_file = File::open(input_path).expect("Failed to open input BMP file");
    let mut bmp_data = Vec::new();
    input_file.read_to_end(&mut bmp_data).expect("Failed to read BMP file");

    // Validate BMP header
    if &bmp_data[0..2] != b"BM" {
        panic!("Not a valid BMP file");
    }

    // Offset to pixel data
    let pixel_array_offset = u32::from_le_bytes(bmp_data[10..14].try_into().unwrap()) as usize;

    // Extract pixel data
    let pixel_data = &bmp_data[pixel_array_offset..];

    // Create COE file
    let mut coe_file = File::create(coe_path).expect("Failed to create COE file");
    coe_file
        .write_all(b"memory_initialization_radix=2;\nmemory_initialization_vector=\n")
        .expect("Failed to write COE header");

    // Process each pixel and write to the COE file
    let mut first = true;
    for chunk in pixel_data.chunks_exact(4) { // RGBA means 4 bytes per pixel
        let r = chunk[2] >> 5; // Top 3 bits of red
        let g = chunk[1] >> 5; // Top 3 bits of green
        let b = chunk[0] >> 6; // Top 2 bits of blue
        let a = chunk[3] >> 7; // Top 1 bit of alpha

        let reduced_pixel = (r << 5) | (g << 2) | (b << 1) | a;

        if !first {
            coe_file.write_all(b",\n").expect("Failed to write separator");
        }
        coe_file
            .write_all(format!("{:08b}", reduced_pixel).as_bytes())
            .expect("Failed to write binary data");

        first = false;
    }

    coe_file.write_all(b";\n").expect("Failed to write COE footer");

    println!("Successfully converted BMP to COE: {}", coe_path);
}
