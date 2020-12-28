# SPBox
Local development box

# Requirements

* Virtual Box [Download Virtual Box](https://www.virtualbox.org/wiki/Downloads)
* Vagrant 2.1.5+ [Download Vagrant](https://www.vagrantup.com/)

# This box includes


* Debian stretch
* MariaDB 10.3
* PHP 7.2
* Apache/2.4.25
* NodeJS 10.12.0
* MailDev
* Composer
* Redis
* Ngrok
* wget, curl, emacs, git, zip

# How to use


First command : ```$ vagrant up```

To use the default host (localhost.local), edit your hosts file in your machine.

Navigate to ```/var/shared/www/``` to start your new web project.

An example with Cakephp

```$ cd /var/shared/www```

```$ sudo composer self-update && composer create-project --prefer-dist cakephp/app my_app_name```

Now run ```$ sudo gvhost app.local /var/shared/www/my_app_name r save```

Point your browser to app.local and enjoy.



# Vagrant was unable to mount VirtualBox shared folders

Follow this commands : 

```vagrant vbguest --do install --no-cleanup```

```vagrant ssh```

```sudo /mnt/VBoxLinuxAdditions.run```

```exit```

```vagrant reload```

