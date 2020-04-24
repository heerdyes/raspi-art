import gizeh
import math
import moviepy.editor as mpy
import os
import sys

if len(sys.argv)!=4:
    print('usage: python3 videoasm.py <imagedir> <audiofile> <videooutfile>')
    raise SystemExit

# arg1 - image sequence directory
imgseqdir=sys.argv[1]
# arg2 - audio file for background
inaudfile=sys.argv[2]
# arg3 - output video file name
outvidfnm=sys.argv[3]

imglist=os.listdir(imgseqdir)
imglist.sort()
imglist=[imgseqdir+'/'+x for x in imglist]

clip=mpy.ImageSequenceClip(imglist,fps=15)
auclip=mpy.AudioFileClip(inaudfile)
fclip=clip.set_audio(auclip)
fclip.write_videofile(outvidfnm)
