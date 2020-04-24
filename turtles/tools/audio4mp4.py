import moviepy.editor as mpy
import os
import sys

if len(sys.argv)!=4:
    print('usage: python3 audio4mp4.py <invidfile> <inaudfile> <outvidfile>')
    raise SystemExit

# arg1 - input video file
invidfnm=sys.argv[1]
# arg2 - input audio file
aufile=sys.argv[2]
# arg3 - output video file
outvidfnm=sys.argv[3]

clip=mpy.VideoFileClip(invidfnm)
auclip=mpy.AudioFileClip(aufile)
fclip=clip.set_audio(auclip)
fclip.write_videofile(outvidfnm)
