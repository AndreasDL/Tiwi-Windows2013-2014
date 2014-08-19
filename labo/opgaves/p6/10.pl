#vervang zoeknaam en .... door je eigen naam
dsquery user -name zoeknaam

dsquery * "CN=.... ,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be" -attr mail objectclass

#thuis (vervang ook loginname door je eigen loginname) :
dsquery user -s 193.190.126.71 -u loginname -p * -name zoeknaam

dsquery * "CN=zoeknaam,OU=EM7INF,OU=Studenten,OU=iii,DC=iii,DC=hogent,DC=be" -s 193.190.126.71
           -u loginname -p * -attr mail objectclass

