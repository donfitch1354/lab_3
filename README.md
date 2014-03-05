lab_3
=====
Author: C1C Ethan Snyder
Lab 3 (Font Controller) 

Mux:
Created a mux module to take an input signal and basically flip it... making 0 corrospond to 7, 2 to 6 etc. This is because when writing the pixels the order is reversed. This was simple to create but i never used it mainly because I used an internal mux in my character gen module (after talking with C2C Nikolas Taormina. 

Character Gen: 
reads in from character buffer and creates a pixel by pixel model of the screen to be created. This was by far the hardest module to implement and gave me a lot of trouble because i didn't have some of the b-functionality inputs tied to signals initially; it took a while to figure out why nothing was showing (en was open). 

Screen Buffer: 
this creates block ram for storing the characters that are needed by the character gen module. My understanding is that it creates each of the 8x16 blocks and stores what pixel values go where. This is fed into the character gen. 

Top level (atlys_lab_vide): 
This is my top level design with incorperated delays. It instantiates the other modules and is responsible for the hardware I/O. 

What I learned: 
Start early (as always) and MAKE SURE you have a solid understanding of what the actual behavioral view of the project is. I would have saved myself a lot of time if i had simply spend several hours really learning what I was trying to do instead of just jumping in.




Documentation: Worked closely with C2C Taormina on almost every part of the lab. Also spoke with C2C Busho about delays and part B functionality. C2C Miller explained in detail his part B functionality. If any further clarification is needed, please ask. 
