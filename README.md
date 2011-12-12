# Erb2Haml

Bulk convert ugly old ERB files in your rails app into new sleek HAML.
You may even delete just converted files optionally. 

`~$ ruby erb2haml.rb -h  
Usage: erb2haml.rb [options] [path1, path2, ...]  
path could be both filepath or path to directory, if no paths are present the script's directory is used'  
    -f, --force                      Force delete source ERB files after being converted`


NOTE: since script is looking for ERB-files recursively, if you define path(s) all ERB files found by that will be converted.
If you don't mention any path current script's directory will be used.


Author: Alexander Kaupanin <kaupanin@gmail.com>
