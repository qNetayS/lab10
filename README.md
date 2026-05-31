# Лабораторная работа №10: Vagrant

**Студент:** qNetayS  
**Дата выполнения:** 2026-05-31  
**Репозиторий:** https://github.com/qNetayS/lab10

---

## Цель работы

Изучить основы системы автоматизации развёртывания и управления виртуальными машинами на примере **Vagrant**.

---

## Ход выполнения

### 1. Настройка переменных окружения

```bash
export GITHUB_USERNAME=qNetayS
export PACKAGE_MANAGER=apt

cd ${GITHUB_USERNAME}/workspace
```
Результат: Переменные окружения настроены
### 2. Установка Vagrant
```
sudo apt update
sudo apt install -y vagrant
vagrant version
```
### 3. Инициализация Vagrant
```
vagrant init bento/ubuntu-19.10
vagrant init -f -m bento/ubuntu-19.10
vagrant version
```
Резульат: Файл Vagrantfile перезаписан минимальной версией.
### 4. Создание директории для общих файлов
```
mkdir -p shared
```
Результат: Создана директория shared для синхронизации файлов.
### 5.Настройка Vagrantfile
Содержимое итогового Vagrantfile:
```
$script = <<-SCRIPT
sudo apt update
sudo apt install -y docker.io
sudo docker pull ubuntu:22.04
sudo docker create -ti --name fastide ubuntu:22.04 bash
sudo docker cp fastide:/home/ubuntu /home/
sudo useradd developer
sudo usermod -aG sudo developer
echo "developer:developer" | sudo chpasswd
sudo chown -R developer /home/developer
SCRIPT

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-vbguest"]
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.network "public_network"
  config.vm.synced_folder('shared', '/vagrant', type: 'rsync')
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "2048"
  end
  config.vm.provision "shell", inline: $script, privileged: true
  config.ssh.extra_args = "-tt"
end
```
### 6. Валидация конфигурации
```
vagrant validate
```
Вывод: vagrant validate

### 7.Запуск виртуальной машины
```
vagrant up --provider=virtualbox
```
Вывод:
```
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'bento/debian-12'...
==> default: Matching MAC address for NAT networking...
==> default: Setting the name of the VM...
==> default: Fixed port collision for 22 => 2222. Now on port 2200.
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
==> default: Adapter 1: nat
==> default: Adapter 2: bridged
==> default: Forwarding ports...
==> default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
==> default: Machine booted and ready!
==> default: Running provisioner: shell...
==> default: Running: inline script
```
### 8.Проверка портов и статуса
vagrant port
```
The forwarded ports for the machine are listed below. Please note that
these values may differ from values configured in the Vagrantfile if the
provider supports automatic port collision detection and resolution.

    22 (guest) => 2222 (host)
```
### 9.Подключение по SSH
```
vagrant ssh
```
Linux debian 6.1.0-25-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.106-3 (2024-08-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri May 31 20:00:00 2026 from 10.0.2.2
vagrant@debian:~$
### 10.Работа со снапшотами
```
vagrant snapshot list
vagrant snapshot push
```
Вывод:
==> default: Snapshotting the machine as 'push_1234567890_123'...
==> default: Snapshot saved! You can restore the snapshot at any time by
==> default: using `vagrant snapshot restore`. You can delete it using
==> default: `vagrant snapshot delete`.
```
vagrant snapshot pop
```
==> default: Restoring the snapshot 'push_1234567890_123'...
==> default: Deleting the snapshot 'push_1234567890_123'...
==> default: Snapshot deleted!
==> default: Resuming suspended VM...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
==> default: Machine booted and ready!












