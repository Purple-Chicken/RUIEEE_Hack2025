## Inspiration
We selected this prompt given at the hackathon to gain knowledge in embedded systems which would prepare use for our future courses at Rutgers.
## What it does
HDMI controller that changes the monitor display. A Rust program processes input images to reduce storage on the Zypo Z7 board, converting .png/.jpg/.gif to 620x480 in 8-bit colors COE file.
## How we built it
We used information the following resources, Rutgers Embedded Systems Labs with similar tasks, online posts/forums on converting image file types to be read by Verilog.
The Verillog program works by using logical functions (gates) to convert original image to a readable format which can be displayed on HDMI stream based on the pins (0:blue 1:green 2:red).

## Challenges we ran into

### Challenges in Rust Image Processing 
Input file into Verilog: During our research phase, we misunderstood which file type could be read by Verilog and how much space the Zypoz7 could effectively display. As a result, we would iterate our image processing program in Rust several times. 
- **1st iteration**: changed image filetype -->.bmp. 
- **2nd iteration**, realized Verilog cannot read .bmp files, so changed the program to process image --> .bmp --> .hex. 
- **3rd Iteration**, realized the image needs to be downscaled more, we added cropping, blur, and color downgrading to 8-bit colors. 
- **4th Iteration**: Realized Verilog needs a .coe file to run, and that our program could convert directly from .bmp to  .coe. 
- **Final Rust image processing description**: Input: image (.png/.jpg/.gif), adds Gaussian blur and margins to compress and change resolution to 620 x 480, reduces color depth to 8-bit, exports a .coe file.

### Challenges in Verilog
Verilog is a difficult program to use since the error locations were not clear. We also lack experience in Verilog/image processing. Testing the Verilog code since we did not have access to a test setup to use when the Judge was not here.

## Accomplishments that we're proud of
Displayed a Pink/Magenta image
More knowledge gained (read on section below)
## What we learned
- Zypoz7 has low storage
- use low color depth and low resolution
- USB OTG, HDMI (input & output), Gigabit Ethernet, 3.5mm audio jack, microSD slot, PMOD connectors, Arduino headers, JTAG port, and GPIO pins.
- Use Verilog to process and send pixel data 
- VGA pins: Red, Green, Blue, Hsync, Vsync
- Colors and horizontal/vertical sync
- Verilog cannot read images directly.
- Convert to bitmap convert to coe file

The techniques and theory behind video generation in the context of VGA are the foundation of the other methods(DVI and HDMI)
## What's next for HDMI Controller
Play **videos/gifs**. Separate the gif into individual frames. Play the frames in order to play the video/gif at a low frame rate. Work with camera feed, same process as videos/gifs but receiving input from a camera on another device.
