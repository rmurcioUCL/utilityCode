open("static1.squarespace.com.png")
//individual image size
a=0;b=0;c=126;d=126;
xf=134;yf=104+gap;
//gap between images
gap=10;count=0;
setOption("BlackBackground", false);
for (i=1;i<21;i++){  //columns
 for (j=1;j<12;j++){  // rows
   makeRectangle(a, b, c, d);
   a=a+xf; c=104+yf;
   run("Crop");
   count=count+1;
   fname = "image"+count;
   //make sure size is what I want
   run("Size...", "width=126 height=126 interpolation=Bilinear");
   //make it binary
   run("Make Binary");
   saveAs("Tiff", fname);
   run("Close All");
 }
a=0;c=126;
}