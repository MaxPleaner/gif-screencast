#### remove frames

Define the following bash function

      gif_framecount_reducer () { # args: $gif_path $frames_reduction_factor
          local orig_gif="${1?'Missing GIF filename parameter'}"
          local reduction_factor=${2?'Missing reduction factor parameter'}
          # Extracting the delays between each frames
          local orig_delay=$(gifsicle -I "$orig_gif" | sed -ne 's/.*delay \([0-9.]\+\)s/\1/p' | uniq)
          # Ensuring this delay is constant
          [ $(echo "$orig_delay" | wc -l) -ne 1 ] \
              && echo "Input GIF doesn't have a fixed framerate" >&2 \
              && return 1
          # Computing the current and new FPS
          local new_fps=$(echo "(1/$orig_delay)/$reduction_factor" | bc)
          # Exploding the animation into individual images in /var/tmp
          local tmp_frames_prefix="/var/tmp/${orig_gif%.*}_"
          convert "$orig_gif" -coalesce +adjoin "$tmp_frames_prefix%05d.gif"
          local frames_count=$(ls "$tmp_frames_prefix"*.gif | wc -l)
          # Creating a symlink for one frame every $reduction_factor
          local sel_frames_prefix="/var/tmp/sel_${orig_gif%.*}_"
          for i in $(seq 0 $reduction_factor $((frames_count-1))); do
              local suffix=$(printf "%05d.gif" $i)
              ln -s "$tmp_frames_prefix$suffix" "$sel_frames_prefix$suffix"
          done
          # Assembling the new animated GIF from the selected frames
          convert -delay $new_fps "$sel_frames_prefix"*.gif "${orig_gif%.*}_reduced_x${reduction_factor}.gif"
          # Cleaning up
          rm "$tmp_frames_prefix"*.gif "$sel_frames_prefix"*.gif
      }
      
and call it with `gif_framecount_reducer out.gif 2` (halfs the frames count)