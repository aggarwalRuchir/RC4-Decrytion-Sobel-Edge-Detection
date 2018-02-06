# RC4-Decrytion-Sobel-Edge-Detection
Project done as a part of ECE337: ASIC Design Laboratory course at Purdue during my undergraduate.

## How the project works
The order of operations as follows:

  * Obtain image data through AHB
  * RC4 decrypt entire image
  * Sobel-Edge Detect image
  * Write image to same memory location using AHB

## ScreenShots
<img src="/main/images/girl.bmp" alt="Original Girl Image" width="200" height="200">          <img src="/main/images/encrypted_girl.bmp" alt="Encrypted Girl Image" width="200" height="200">         <img src="/main/docs/decrypted_girl.bmp" alt="RC4 Decrypted Girl Image" width="200" height="200">
 <img src="/main/docs/edge_detected_girl.bmp" alt="Sobel-Edge Detected Girl" width="200" height="200">

Here:
  1. Original image
  1. Encrypted image through python code
  1. RC4 decrypted image through designed ASIC
  1. Sobel-Edge Detected image through designed ASIC

## License
MIT License. See [LICENSE](LICENSE) for more details.
