# Owong_XDS2102A Bin file Reader

Tool to display bin files created by an Owong XDS2102A Oscilloscope.

File format:

SPBXDS followed by the 4 Bytes length of the following JSON description  
eg.: A8020000 meaning 680 Bytes of JSON description
![Owong Image](https://github.com/frcocoatst/Owong_XDS2102A/blob/master/p0.jpg)

followed by 10000 2Bytes Values (corresponds Data_length 10000 in JSON block)
![Owong Image](https://github.com/frcocoatst/Owong_XDS2102A/blob/master/p2.jpg)

In case a second channel is stored the JSON block is longer
eg.: 09050000 meaning 1289 Bytes of JSON description
![Owong Image](https://github.com/frcocoatst/Owong_XDS2102A/blob/master/p1.jpg)

Followed by 2 * 10000 2 Bytes Values ...

Hint: This is very experimental, not sure if I decode the values right ...


