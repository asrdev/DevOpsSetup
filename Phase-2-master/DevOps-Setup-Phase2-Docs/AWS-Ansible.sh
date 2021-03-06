#Reference: https://www.youtube.com/watch?v=DZ84onseKek

#Once connected to redhat server, login to root user : sudo -i
sudo -i

#hostname AnsibleServer (run this command from root user)
hostname AnsibleServer

#vi /etc/hostname ==> remove the first line and update to "AnsibleServer"

#Or

echo AnsibleServer > /etc/hostname

#logout from root & ec2 user. and login again.

#[ec2-user@AnsibleServer ~]$ --> you will see the host name as "AnsibleServer".

#1. Run the below command from root user: sudo -i

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#2. Install ansible: yum install -y ansible
yum install -y ansible

#Check the ansible version
echo" Output:
	[root@AnsibleServer ~]# ansible --version
	ansible 2.6.2
	  config file = /etc/ansible/ansible.cfg
	  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
	  ansible python module location = /usr/lib/python2.7/site-packages/ansible
	  executable location = /bin/ansible
	  python version = 2.7.5 (default, Feb 20 2018, 09:19:12) [GCC 4.8.5 20150623 (Red Hat 4.8.5-28)]
"
  
#Ansible installed at the location --> /etc/ansible

#3. Run the command	-- ls /etc/ansible/ or ll /etc/ansible/

ll /etc/ansible/

# You will see the files/folder: ansible.cfg hosts roles
echo" Output:
-rw-r--r--. 1 root root 19549 Jul 28 20:07 ansible.cfg
-rw-r--r--. 1 root root  1016 Jul 28 20:07 hosts
drwxr-xr-x. 2 root root     6 Jul 28 20:07 roles
"

# 4. Run the command: ssh-keygen -t rsa

ssh-keygen -t rsa

echo" Output:
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:+TOGGmciT3p+ZWKR9ppJC7Eow8gTtqVNAV000A+y/NE root@AnsibleServer
The key's randomart image is:
+---[RSA 2048]----+
| .o.=+           |
|   + o.          |
|  . + +  .       |
| o = ..E+.       |
|ooB ...+So       |
|.=+...o +o+      |
|  .o. +++O=      |
|     =.**. o     |
|    .o+.         |
+----[SHA256]-----+
"

#Public key generated at --> cat /root/.ssh/id_rsa.pub

#Keep open the file id_rsa.pub and copy the key. (this needs to be pasted in client server location)

#5. Create an another RedHat server and connect to it, we will consider it as cleint server.
#login to the server as root.
sudo -i

#hostname ClientServer (run this command from root user)
hostname ClientServer

#vi /etc/hostname ==> remove the first line and update to "ClientServer"

#logout from root & ec2 user. and login again.

#[ec2-user@ClientServer ~]$ --> you will see the host name as "ClientServer".

6.  

	#6.1. login to root: sudo -i
	
		sudo -i

	#6.2. paste the key which is copied from AnsibleServer and save the file.

		vi /root/.ssh/authorized_keys

	#6.3. (Optional)Update the host name from HOSTNAME=localhost.localdomain to HOSTNAME=ClientServer in the file vi /etc/sysconfig/network. logout from ec2, root user and login again and then login to root user.

	#6.4. vi /etc/ssh/sshd_config : uncomment the line "PermitRootLogin yes".

		/etc/init.d/sshd restart

	#6.5. add the cient host IP details in the file vi /etc/hosts (add as a new line) in ClientServer.

		18.191.250.211 AnsibleServer

	#6.6. Test the connection.
	
		ping AnsibleServer

#7. Go to the AnsibleServer 

	#7.1. root user --> vi /etc/hosts --> 18.219.241.116 ClientServer (repeat the 6.5).
	
		18.219.241.116 ClientServer

	#7.2. login to ClientServer from AnsibleServer : ssh ClientServer (if successfully logged in to client, then logout and try ansible commands)
	
		ssh ClientServer

#So far we just installed Ansible.
#Establised a connection b/w the two servers AnsibleServer & ClientServer. This is not related to Ansible.
#Practice Ansible now.

#8. Ansible: Install somethiong on ClientServer machine from the AnsibleServer using Ansible software.

	#8.1. Add hosts details(add below two lines) in the ansible hosts file : vi /etc/ansible/hosts

		[amazonweb]
		ClientServer

	#8.2. Test the connection using Ansible:
	
		#Test the connection to the particular server.
		ansible ClientServer -m ping
		
		or
		
		#Test the connection to the group of servers, here amazonweb is the group name which we configured in ansible hosts file.
		ansible amazonweb -m ping
		
		or
		
		#Test the connection to the all the servers which are configured as all the groups in ansible hosts file.
		ansible all -m ping

		echo''' Output:
		[root@AnsibleServer ~]# ansible ClientServer -m ping
		ClientServer | SUCCESS => {
			"changed": false,
			"ping": "pong"
		}
		[root@AnsibleServer ~]# ansible all -m ping
		ClientServer | SUCCESS => {
			"changed": false,
			"ping": "pong"
		}
		[root@AnsibleServer ~]# ansible amazonweb -m ping
		ClientServer | SUCCESS => {
			"changed": false,
			"ping": "pong"
		}
		'''

	#8.3. create a folder "playbooks" and cd playbooks.

	vi ansi_playbook.yml #create yml file and add below snippet.

	- hosts: amazonweb
	  tasks:
	   - name: install tree
	     yum: name=tree update_cache=yes state=latest

	8.4. ansible-playbook ansi_playbook.yml.
	
		PLAY [amazonweb] ***************************************************************

		TASK [Gathering Facts] *********************************************************
		ok: [client]

		TASK [install tree] ************************************************************
		changed: [client]

		PLAY RECAP *********************************************************************
		client                     : ok=2    changed=1    unreachable=0    failed=0

#Ad-hoc commands example-1: Copy the file from AnsibleServer to ClientServer (make sure the dest path exists on client server)
ansible client -m copy -a "src=playbooks/ansi_playbook.yml dest=/root/dest"

#Tip: Uninstall package "rpm -e tree" 
======================================================================================================

Scenario-1: Download an artifact from Nexus and depoy on TomCat.

---
- hosts: amazonweb
  vars:
  - warName: jenkins.war
  - warRemotePath: /etc/wars/

  tasks:
  - name: Download WAR to server
	get_url:
	  url: http://13.59.32.120:8081/nexus/content/repositories/releases/com/devops/webapp/WebApp/1.0.0-2/WebApp-1.0.0-2.war
	  dest: /etc/wars/

  - name: Deploy WAR file
	command: mv /etc/wars/WebApp-1.0.0-2.war /var/lib/tomcat7/webapps/

======================================================================================================

Scenario-2: Call one yml file from other yml file. 

---
- import_playbook: other_file.yml


Note: 'include' for playbook includes. You should use 'import_playbook' instead. This feature will be removed in
version 2.8.

======================================================================================================

Scenario-3: copy the file from AnsibleServer machine to ClientServer, and install the apache pakage.

- hosts: amazonweb
  tasks:
    - name: install httpd
      yum: name=httpd state=installed
    - name: copy index.html
      copy: src=files/index.html dest=/var/www/html/index.html
    - name: start apache
      service:
       name: httpd
       state: restarted

# Once the above palybook run successfully, launch only the IP address of the cleint machine: http://13.58.52.250, it will run index.html file.
======================================================================================================
Scenario-4: 

- hosts: ec2-13-59-32-120.us-east-2.compute.amazonaws.com
  tasks:
    - name: install httpd
      action: yum name=httpd state=installed
    - name: copy index.html
      copy: src=files/index.html dest=/var/www/html/index.html
    - name: start apache
      service:
       name: httpd
       state: restarted


	   ansible-playbook ansi_playbook2.yml
	   ansible-playbook -v ansi_playbook2.yml  (verbose mode)
	   ansible-playbook -v ansi_playbook2.yml --step (interacting with user to get the approval on next task execution.)
	   
	   -v = verbore for detailed execution status.
	   --step = y/n/c (interacting with user to get the approval on next task execution.)
Output:
[root@RedhatServer playbooks]# ansible-playbook ansi_playbook2.yml

PLAY [amazonweb] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************
ok: [client]

TASK [install httpd] ***************************************************************************************************************************************************************************
ok: [client]

TASK [copy index.html] *************************************************************************************************************************************************************************
changed: [client]

TASK [start apache] ****************************************************************************************************************************************************************************
changed: [client]

PLAY RECAP *************************************************************************************************************************************************************************************
client                     : ok=4    changed=2    unreachable=0    failed=0

======================================================================================================

Scenario-5: Deploy the package the to tomcat using ansible playbook

- hosts: ClientServer

  tasks:
  - name: Deploy WAR file
    copy: src=/root/.jenkins/workspace/FreeStyleJob-Deploy-Playbook/target/WebApp-1.war dest=/root/tomcat7/webapps/

======================================================================================================

Scenario-6: Deploy the package the to tomcat using ansible playbook by passing the Jenkins variables

- hosts: ClientServer

  tasks:
  - name: Deploy WAR file
    copy: src={{WORKSPACE}}/target/WebApp-{{releaseVersion}}.war dest=/root/tomcat7/webapps/

#Configure extra vars in adanced section as key & value format.

#or Ad-hoc Command: ansible-playbook --extra-vars '{"WORKSPACE":"${WORKSPACE}", "releaseVersion":"${releaseVersion}" }' /etc/ansible/playbooks/warDeployWithVariables.yml

======================================================================================================
