import moviepy.editor as mpy
import os
import sys

if len(sys.argv)!=5:
    print('usage: python3 audio4mp4.py <invidfile> <inaudfile> <omitseconds> <outvidfile>')
    raise SystemExit

# arg1 - input video file
invidfnm=sys.argv[1]
# arg2 - input audio file
aufile=sys.argv[2]
# arg3 - audio first n seconds omit
omitseconds=sys.argv[3]
# arg4 - output video file
outvidfnm=sys.argv[4]

clip=mpy.VideoFileClip(invidfnm)
auclip=mpy.AudioFileClip(aufile)
if omitseconds != '_':
    auclip=auclip.fl_time(lambda: int(omitseconds)+t, keep_duration=True)
fclip=clip.set_audio(auclip)
fclip.write_videofile(outvidfnm)
