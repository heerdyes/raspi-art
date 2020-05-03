import moviepy.editor as mpy
import os
import sys

if len(sys.argv)!=5:
    print('usage: python3 audio4mp4.py <invidfile> <inaudfile> <outvidfile> <introduration>')
    raise SystemExit

# arg1 - input video file
invidfnm=sys.argv[1]
# arg2 - input audio file
aufile=sys.argv[2]
# arg3 - output video file
outvidfnm=sys.argv[3]
# arg4 - intro duration
introduration=int(sys.argv[4])

intropart=mpy.TextClip('triangularish',fontsize=30,color='red')
intropart=intropart.set_pos('center').set_duration(introduration)

clip=mpy.VideoFileClip(invidfnm)
preclip=mpy.concatenate_videoclips([intropart,clip])
preclip.write_videofile('preclip.mp4')

auclip=mpy.AudioFileClip(aufile)
fclip=preclip.set_audio(auclip)
fclip.write_videofile(outvidfnm)
