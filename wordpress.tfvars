image= "wordpress"
tag= "5.75.8-apache"
replicas= 1
storage= 10
storagename= "manual"
accessMode= "ReadWriteOnce"
port= 80
namespace= "wordpress"
volume_path= "/mnt/data"
realesename= "wordpress"
chart= "./wordpress"
file= "./wordpress/values.yaml"
pvname= "wordpress-pv"
pvcname= "wordpress-pvc"