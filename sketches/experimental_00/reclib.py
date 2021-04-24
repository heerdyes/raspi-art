def d(msg):
  print(msg)

def genoneliner(fn,fmtcmd):
  d("[genoneliner] "+fn)
  with open(fn,'w') as f:
      f.write(fmtcmd)

def genscripts(iw,ih):
  d('[genscripts] generating ffmpeg command scripts in img/...');
  genoneliner(
    'img/mkvideo.sh',
    'ffmpeg -r 24 -f image2 -s %dx%d -i ps_%%04d.png -vcodec h264 -crf 25 -pix_fmt yuv420p output.mp4'%(iw,ih))
  genoneliner(
    'img/mkgif.sh',
    'ffmpeg -r 24 -f image2 -s %dx%d -i ps_%%04d.png output.gif'%(iw,ih))
