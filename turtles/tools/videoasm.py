import gizeh
import math
import moviepy.editor as mpy
import os
import sys

if len(sys.argv)!=5:
    print('usage: python3 videoasm.py <imagedir> <audiofile> <omitseconds> <videooutfile>')
    raise SystemExit

# arg1 - image sequence directory
imgseqdir=sys.argv[1]
# arg2 - audio file for background
inaudfile=sys.argv[2]
# arg3 - audio first n seconds omit
omitseconds=sys.argv[3]
# arg4 - output video file name
outvidfnm=sys.argv[4]

imglist=os.listdir(imgseqdir)
imglist.sort()
imglist=[imgseqdir+'/'+x for x in imglist]

clip=mpy.ImageSequenceClip(imglist,fps=15)
if inaudfile != '_':
    auclip=mpy.AudioFileClip(inaudfile)
    if omitseconds != '_':
        auclip=auclip.fl_time(lambda: int(omitseconds)+t)
    clip=clip.set_audio(auclip)
clip.write_videofile(outvidfnm)
