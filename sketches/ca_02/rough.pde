/*
 // division limiter
 if (computedstate<0) computedstate=abs(computedstate/2);
 else if (computedstate>255) computedstate=computedstate/2;
 */

/*
 // reflection
 if (computedstate<0) computedstate=abs(computedstate);
 else if (computedstate>255) computedstate=computedstate-255;
 */

/*
 // damped reflection
 if (computedstate<0) computedstate=abs(computedstate)*damper;
 else if (computedstate>255) computedstate=255-(computedstate-255)*damper;
 */

/*
 // quantum information superhighway
 if (computedstate<0) computedstate=255+computedstate;
 else if (computedstate>255) computedstate=computedstate-255;
 */
