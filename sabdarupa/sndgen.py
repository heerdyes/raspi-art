import numpy as np
import wavio
import math
import matplotlib.pyplot as plt

# wave function space
def tgen(a,T,rate):
	t=np.linspace(a,T,T*rate,endpoint=False)
	return t

def hn(f,t,n):
	x=(1.0/n)*np.sin(2*np.pi*(n*f)*t)
	return x

def e(k,t):
	x=math.e**(k*t)
	return x

def dhn(f,t,n,k):
	hx=hn(f,t,n)
	x=e(k,t)*hx
	return x

def hnlfo(f,t,n,m,q,fn):
	x=(1.0/n)*np.sin(2*np.pi*(n*fn(f,t,m,q))*t)
	return x

# interference beats
def althn(f,t,a,b,d=10,k=0):
	df=d*np.sin(np.pi*t)
	print('min(df): %f'%np.min(df))
	ax=a*np.sin(2*np.pi*f*t)+b*np.cos(2*np.pi*(f+df)*t)
	print('min(ax): %f'%np.min(ax))
	x=e(k,t)*ax
	return x

#tone bank
def violin_organ(t,dk,f):
	if dk>0:
		raise Exception('[fatal] possibly dangerous exponentiation index: '+dk)
	x=e(dk,t)*(dhn(f,t,1,-3)+dhn(f,t,2,-2)+dhn(f,t,4,-3)+dhn(f,t,8,-4)+dhn(f,t,16,-8))
	return x

def odd_organ(t,dk,f):
	if dk>0:
		raise Exception('[fatal] possibly dangerous exponentiation index: '+dk)
	x=e(dk,t)*(dhn(f,t,1,-1)+dhn(f,t,3,-1.5)+dhn(f,t,5,-2.0)+dhn(f,t,7,-2.5)+dhn(f,t,9,-3.0))
	return x

def dk_organ(t,dk,f):
	if dk>0:
		raise Exception('[fatal] possibly dangerous exponentiation index: '+dk)
	x=e(dk,t)*(hnlfo(f,t,1,2,10,lambda y,u,v,w: y+v*np.sin(w*u))+dhn(f,t,5,-1.5))
	return x

def pluck(t,dk,f):
	if dk>0:
		raise Exception('[fatal] possibly dangerous exponentiation index: '+dk)
	x=dhn(f,t,1,dk)
	return x

# global parameter space
r=44100    # samples per second
T=10       # sample duration (seconds)
f=384.0    # sound frequency (Hz)
g=320.0
lfo1=5.0
a1=3.0
k=-0.8     # decay coeff

# flow
t=tgen(0,T,r)
snd=althn(f,t,0.6,0.6,6,-0.25)
plt.plot(snd)
plt.savefig('snd.png')

# Write the samples to a file
wavio.write('snd.wav', snd, r, sampwidth=3)
