# Credit goes to http://unix.stackexchange.com/a/165147/65890

echo "enter the following commands:"

echo ""

echo "ffcast -w % ffmpeg -f x11grab -show_region 1 -framerate 20 -video_size %s -i %D+%c -codec:v huffyuv -vf crop=\"iw-mod(iw\\,2):ih-mod(ih\\,2)\" out.avi;"

echo ""

echo "ffmpeg -i out.avi -pix_fmt rgb24 out.gif;"

echo ""

echo "convert -limit memory 1 -limit map 1 -layers Optimize out.gif out_optimised.gif;"
