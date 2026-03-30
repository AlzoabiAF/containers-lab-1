# Отчет по практической работе №3
## Студент: [ФИО]
## Группа: [номер группы]
## Дата выполнения: [дата]
### 1. Подготовка узлов
#### 1.1 Версия ОС и настройки
```
root@k8s-master:~/k8s-lab3# cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 12 (bookworm)"
NAME="Debian GNU/Linux"
VERSION_ID="12"
VERSION="12 (bookworm)"
VERSION_CODENAME=bookworm
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```
#### 1.2 Отключение swap
```
root@k8s-master:~/k8s-lab3# free -m
               total        used        free      shared  buff/cache   available
Mem:            3919        1715         165           3        2204        2204
Swap:              0           0           0
```
#### 1.3 Модули ядра
```
root@k8s-master:~/k8s-lab3# lsmod | grep -E "overlay|br_netfilter"
br_netfilter           32768  0
bridge                262144  1 br_netfilter
overlay               135168  29
```
### 2. Установка containerd
#### 2.1 Версия containerd
```
root@k8s-master:~/k8s-lab3# containerd --version
containerd containerd.io v2.2.2 301b2dac98f15c27117da5c8af12118a041a31d9
```
#### 2.2 Конфигурация containerd
```
root@k8s-master:~/k8s-lab3# cat /etc/containerd/config.toml | grep SystemdCgroup
            SystemdCgroup = true
```            

### 3. Установка kubeadm
#### 3.1 Версии компонентов
```
root@k8s-master:~/k8s-lab3# kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"28", GitVersion:"v1.28.15", GitCommit:"841856557ef0f6a399096c42635d114d6f2cf7f4", GitTreeState:"clean", BuildDate:"2024-10-22T20:33:16Z", GoVersion:"go1.22.8", Compiler:"gc", Platform:"linux/arm64"}
root@k8s-master:~/k8s-lab3# kubelet --version
Kubernetes v1.28.15
root@k8s-master:~/k8s-lab3# kubectl version --client
Client Version: v1.28.15
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
```
### 4. Инициализация кластера
#### 4.1 Узлы кластера
```
root@k8s-master:~/k8s-lab3# kubectl get nodes -o wide
NAME          STATUS   ROLES           AGE    VERSION    INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
k8s-master    Ready    control-plane   2d6h   v1.28.15   10.0.0.1      <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-44-arm64   containerd://2.2.2
k8s-worker1   Ready    worker          2d6h   v1.28.15   10.0.0.2      <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-44-arm64   containerd://2.2.2
k8s-worker2   Ready    worker          151m   v1.28.15   10.0.0.3      <none>        Debian GNU/Linux 12 (bookworm)   6.1.0-44-arm64   containerd://2.2.2
```
#### 4.2 Поды в namespace kube-system
```
root@k8s-master:~/k8s-lab3# kubectl get pods -n kube-system
NAME                                 READY   STATUS    RESTARTS   AGE
coredns-5dd5756b68-98fvh             1/1     Running   0          2d6h
coredns-5dd5756b68-b64d7             1/1     Running   0          2d6h
etcd-k8s-master                      1/1     Running   0          2d6h
kube-apiserver-k8s-master            1/1     Running   0          2d6h
kube-controller-manager-k8s-master   1/1     Running   3          2d6h
kube-proxy-gm9dw                     1/1     Running   0          2d6h
kube-proxy-pxpvj                     1/1     Running   0          151m
kube-proxy-r8n96                     1/1     Running   0          2d6h
kube-scheduler-k8s-master            1/1     Running   3          2d6h
```
### 5. Сетевые компоненты
#### 5.1 Calico
```
root@k8s-master:~/k8s-lab3# kubectl get pods -n calico-system
NAME                                       READY   STATUS    RESTARTS   AGE
calico-kube-controllers-69f9ccf68f-mgrzm   1/1     Running   0          2d6h
calico-node-b69dc                          1/1     Running   0          151m
calico-node-sxbnx                          1/1     Running   0          2d6h
calico-node-vtzbm                          1/1     Running   0          2d6h
calico-typha-5f9cc6ddd6-c4wbh              1/1     Running   0          151m
calico-typha-5f9cc6ddd6-nr9dw              1/1     Running   0          2d6h
csi-node-driver-8wcsd                      2/2     Running   0          2d6h
csi-node-driver-lghcl                      2/2     Running   0          2d6h
csi-node-driver-zfj4d                      2/2     Running   0          151m
```
#### 5.2 MetalLB
```
kubectl get pods -n metallb-system
NAME                          READY   STATUS    RESTARTS   AGE
controller-5c6b6c8447-7lfkl   1/1     Running   0          152m
speaker-55s2d                 1/1     Running   0          2d6h
speaker-5bjcj                 1/1     Running   0          152m
speaker-ztv56                 1/1     Running   0          2d6h
root@k8s-master:~/k8s-lab3# kubectl get ipaddresspools -n metallb-system
NAME         AUTO ASSIGN   AVOID BUGGY IPS   ADDRESSES
first-pool   true          false             ["10.0.0.100-10.0.0.200"]
```
#### 5.3 Ingress Controller
```
kubectl get pods -n ingress-nginx
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-7xzsf        0/1     Completed   0          2d
ingress-nginx-controller-6dc9c5fb7c-4fx7d   1/1     Running     0          153m
root@k8s-master:~/k8s-lab3# kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             NodePort       10.110.253.113   <none>        80:31127/TCP,443:30699/TCP   2d
ingress-nginx-controller-admission   ClusterIP      10.96.169.1      <none>        443/TCP                      2d
ingress-nginx-controller-lb          LoadBalancer   10.109.34.163    10.0.0.100    80:31716/TCP,443:32366/TCP   2d
```
### 6. Развернутое приложение
#### 6.1 Все ресурсы в namespace lab3-app
```
root@k8s-master:~/k8s-lab3# kubectl get all -n lab3-app
NAME                            READY   STATUS    RESTARTS       AGE
pod/go-app-57cccf7c85-jrbdb     1/1     Running   1 (108m ago)   153m
pod/go-app-57cccf7c85-n46hg     1/1     Running   1 (108m ago)   153m
pod/go-app-57cccf7c85-wh5dc     1/1     Running   4 (109m ago)   34h
pod/nginx-7fdcf7c4f8-7b8j4      1/1     Running   0              34h
pod/nginx-7fdcf7c4f8-bl68s      1/1     Running   0              153m
pod/postgres-6d75f85ccf-x27vn   1/1     Running   0              153m

NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/go-app     ClusterIP   10.102.43.161    <none>        8081/TCP   34h
service/nginx      ClusterIP   10.108.219.186   <none>        80/TCP     20m
service/postgres   ClusterIP   10.99.40.104     <none>        5432/TCP   34h

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/go-app     3/3     3            3           34h
deployment.apps/nginx      2/2     2            2           34h
deployment.apps/postgres   1/1     1            1           34h

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/go-app-57cccf7c85     3         3         3       34h
replicaset.apps/go-app-6b88cd4db9     0         0         0       34h
replicaset.apps/nginx-7fdcf7c4f8      2         2         2       34h
replicaset.apps/postgres-6d75f85ccf   1         1         1       34h
```

#### 6.2 PersistentVolumeClaim
```
root@k8s-master:~/k8s-lab3# kubectl get pvc -n lab3-app
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
postgres-pvc   Bound    pvc-4bcbd4d7-0971-4fa9-acac-2e5040dba54b   5Gi        RWO            local-path     34h
```
### 7. Скриншоты
#### 7.1 Главная страница приложения
![Главная страница](screenshots/3/1.png)
#### 7.2 Список пользователей из БД
![Users list](screenshots/3/2.png)
### 8. Тестирование отказоустойчивости
#### 8.1 Симуляция отказа узла
```
root@k8s-worker1:~# systemctl stop kubelet

^Croot@k8s-master:~/k8s-lab3# kubectl get nodes -w
NAME          STATUS     ROLES           AGE    VERSION
k8s-master    Ready      control-plane   2d8h   v1.28.15
k8s-worker1   NotReady   worker          2d8h   v1.28.15
k8s-worker2   Ready      worker          4h     v1.28.15

root@k8s-master:~/k8s-lab3# kubectl get pods -n lab3-app -o wide -w
NAME                        READY   STATUS        RESTARTS   AGE     IP              NODE          NOMINATED NODE   READINESS GATES
go-app-57cccf7c85-42z4z     1/1     Running       0          7m11s   10.244.126.3    k8s-worker2   <none>           <none>
go-app-57cccf7c85-bc7jx     1/1     Running       0          7m11s   10.244.126.4    k8s-worker2   <none>           <none>
go-app-57cccf7c85-gg24g     1/1     Terminating   0          7m11s   10.244.194.84   k8s-worker1   <none>           <none>
go-app-57cccf7c85-vr67h     1/1     Running       0          28s     10.244.126.8    k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-5z658      1/1     Running       0          28s     10.244.126.10   k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-6k2z8      1/1     Running       0          28s     10.244.126.11   k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-7b8j4      1/1     Terminating   0          35h     10.244.194.76   k8s-worker1   <none>           <none>
nginx-7fdcf7c4f8-bl68s      1/1     Terminating   0          4h6m    10.244.194.79   k8s-worker1   <none>           <none>
postgres-6d75f85ccf-jfhvq   1/1     Running       0          14s     10.244.126.12   k8s-worker2   <none>           <none>
```
#### 8.2 Проверка сохранности данных
```
root@k8s-master:~/k8s-lab3# kubectl delete pod -n lab3-app -l app=postgres
pod "postgres-6d75f85ccf-zmfdx" deleted
root@k8s-master:~/k8s-lab3# kubectl get pods -n lab3-app -o wide -w
NAME                        READY   STATUS        RESTARTS   AGE     IP              NODE          NOMINATED NODE   READINESS GATES
go-app-57cccf7c85-42z4z     1/1     Running       0          7m11s   10.244.126.3    k8s-worker2   <none>           <none>
go-app-57cccf7c85-bc7jx     1/1     Running       0          7m11s   10.244.126.4    k8s-worker2   <none>           <none>
go-app-57cccf7c85-gg24g     1/1     Terminating   0          7m11s   10.244.194.84   k8s-worker1   <none>           <none>
go-app-57cccf7c85-vr67h     1/1     Running       0          28s     10.244.126.8    k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-5z658      1/1     Running       0          28s     10.244.126.10   k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-6k2z8      1/1     Running       0          28s     10.244.126.11   k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-7b8j4      1/1     Terminating   0          35h     10.244.194.76   k8s-worker1   <none>           <none>
nginx-7fdcf7c4f8-bl68s      1/1     Terminating   0          4h6m    10.244.194.79   k8s-worker1   <none>           <none>
postgres-6d75f85ccf-jfhvq   1/1     Running       0          14s     10.244.126.12   k8s-worker2   <none>           <none>
^Croot@k8s-master:~/k8s-lab3kubectl delete pod -n lab3-app -l app=postgreses
pod "postgres-6d75f85ccf-jfhvq" deleted
root@k8s-master:~/k8s-lab3# kubectl get pods -n lab3-app -o wide -w
NAME                        READY   STATUS        RESTARTS   AGE     IP              NODE          NOMINATED NODE   READINESS GATES
go-app-57cccf7c85-42z4z     1/1     Running       0          7m44s   10.244.126.3    k8s-worker2   <none>           <none>
go-app-57cccf7c85-bc7jx     1/1     Running       0          7m44s   10.244.126.4    k8s-worker2   <none>           <none>
go-app-57cccf7c85-gg24g     1/1     Terminating   0          7m44s   10.244.194.84   k8s-worker1   <none>           <none>
go-app-57cccf7c85-vr67h     1/1     Running       0          61s     10.244.126.8    k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-5z658      1/1     Running       0          61s     10.244.126.10   k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-6k2z8      1/1     Running       0          61s     10.244.126.11   k8s-worker2   <none>           <none>
nginx-7fdcf7c4f8-7b8j4      1/1     Terminating   0          35h     10.244.194.76   k8s-worker1   <none>           <none>
nginx-7fdcf7c4f8-bl68s      1/1     Terminating   0          4h6m    10.244.194.79   k8s-worker1   <none>           <none>
postgres-6d75f85ccf-pbg7g   1/1     Running       0          1s      10.244.126.13   k8s-worker2   <none>           <none>
^Croot@k8s-master:~/k8s-lab3# kubectexec -it -n lab3-app deployment/postgres -- psql -U postgres -d myapp -c "SELECT * FROM users;"
 id |        name        |         created_at
----+--------------------+----------------------------
  1 | Production Cluster | 2026-03-29 09:56:19.225065
  2 | kubeadm User       | 2026-03-29 09:56:19.225065
  3 | Calico Network     | 2026-03-29 09:56:19.225065
  4 | MetalLB User       | 2026-03-29 09:56:19.225065
(4 rows)
```
### 9. Ответы на контрольные вопросы
1. **Какие компоненты входят в control plane и какова их роль?**
   - **kube-apiserver** — центральная точка входа в кластер (REST API), аутентификация/авторизация, валидация объектов, запись/чтение состояния.
   - **etcd** — распределённое key-value хранилище, где хранится «истина» о состоянии кластера (все объекты и конфигурация).
   - **kube-scheduler** — назначает Pod’ы на узлы, выбирая подходящий Node по ресурсам/ограничениям/политикам.
   - **kube-controller-manager** — набор контроллеров, которые приводят фактическое состояние к желаемому (Deployment/ReplicaSet, Node controller и т.д.).
   - Дополнительно в кластере работают **kubelet** (агент на каждом узле, запускает контейнеры через runtime) и **kube-proxy** (правила сетевого доступа к Service), но они относятся к node-компонентам, не к control plane.

2. **Чем отличается развертывание с kubeadm от использования Minikube?**
   - **kubeadm** — инструмент для установки «настоящего» Kubernetes на выделенных узлах (как в работе: отдельный control plane `k8s-master` и worker’ы), с максимальной близостью к production: реальные сети/узлы, отдельный container runtime (`containerd`), полноценные аддоны (Calico/MetalLB/Ingress).
   - **Minikube** — локальный «учебный»/dev-кластер обычно на одной машине (VM/контейнер/драйвер), проще в запуске и обслуживании, но часто имеет упрощения и отличается от «боевого» окружения по сети, балансировке и инфраструктуре.

3. **Для чего нужен CNI-плагин и какую роль выполняет Calico?**
   - **CNI (Container Network Interface)** отвечает за создание сетевого подключения Pod’ов: назначение IP, настройку маршрутизации/туннелей, чтобы Pod’ы могли общаться между узлами, а также за базовую интеграцию сети с Kubernetes.
   - **Calico** в этом кластере обеспечивает pod-to-pod связность между нодами и поддержку **NetworkPolicy** (сетевые политики). В отчёте видно, что Calico развёрнут в `calico-system` и обеспечивает работоспособную межнодовую сеть для приложения.

4. **В чем разница между Service типа NodePort, LoadBalancer и Ingress?**
   - **NodePort**: открывает порт на *каждом* узле и проксирует трафик на Service (доступ вида `NodeIP:NodePort`). В отчёте Ingress Controller также имеет Service типа NodePort.
   - **LoadBalancer**: предоставляет внешний IP и балансирует трафик на Service. В «голом металле» внешний IP обычно выдаёт **MetalLB**. В работе это видно на примере `ingress-nginx-controller-lb`, который получил внешний адрес `10.0.0.100`.
   - **Ingress**: HTTP/HTTPS-маршрутизация на уровне L7 (хосты/пути), которая направляет запросы на разные Service внутри кластера. В манифестах `k8s/3/05-ingress.yaml` настроены правила для домена `lab3.k8s.local`: `/` → Service `nginx`, `/api` → Service `go-app`.

5. **Как обеспечивается отказоустойчивость control plane?**
   - Отказоустойчивость control plane достигается **масштабированием control plane** (несколько control-plane узлов) и **кластером etcd** (обычно 3 или 5 участников) + балансировщиком перед `kube-apiserver`.
   - В текущей лабораторной сборке control plane представлен одним узлом (`k8s-master`), поэтому это **не HA-конфигурация**: при отказе master’а управление кластером станет недоступно, хотя workload на worker’ах может продолжать работать до деградации.
### 10. Выводы
В ходе работы был собран Kubernetes-кластер на Debian 12 с помощью kubeadm (control plane + два worker’а), настроен container runtime `containerd`, подключены сетевые компоненты Calico (CNI), MetalLB (выдача внешних IP для Service типа LoadBalancer) и NGINX Ingress Controller (маршрутизация HTTP по хосту/пути).

Основные сложности были связаны с подготовкой узлов (отключение swap, загрузка модулей ядра `overlay`/`br_netfilter`, корректная настройка `containerd` с `SystemdCgroup=true`), а также с пониманием сетевой части: как CNI обеспечивает связность Pod’ов, как MetalLB раздаёт адреса из пула, и как Ingress правилами связывает домен и пути с Service’ами приложения.

Практика помогла лучше понять принцип «желаемого состояния» в Kubernetes: Deployment поддерживает нужное число реплик (в работе `go-app` — 3, `nginx` — 2), при проблемах с узлом Pod’ы пересоздаются на доступных нодах, а данные PostgreSQL сохраняются благодаря PVC (после пересоздания Pod’а данные из БД остались доступными, что подтверждено запросом `SELECT * FROM users;`). В результате стало яснее, как взаимодействуют control plane, CNI и сервисные абстракции (Service/Ingress) при построении отказоустойчивого приложения.