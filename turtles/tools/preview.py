from moviepy.editor import *
import pygame
import sys

if len(sys.argv)!=2:
    print('usage: python3 preview.py <moviefile>')
    raise SystemExit

vf=sys.argv[1]
pygame.display.set_caption('['+vf+']')

clip=VideoFileClip(vf)
clip.preview()

pygame.quit()
