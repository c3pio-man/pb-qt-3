#!/usr/bin/python3

import argparse
import os
import sys
import subprocess
import json
import hashlib
import grp

default_image = "pocketbook_build_marchpat:6.7"

env = {
}
volumes = [
#    f"{os.getcwd()}:/usr/local/build:rw",
#    f"{os.getcwd()}/cross-compilers/gcc-4.9.2-arm-linux-gnueabihf:/usr/local/gcc-4.9.2-arm-linux-gnueabihf:ro",
#    f"{os.getcwd()}/cross-compilers/gcc-4.6.2-glibc-2.13-linaro-multilib-2011.12:/usr/local/gcc-4.6.2-glibc-2.13-linaro-multilib-2011.12:ro",
    f"{os.environ.get('HOME', '$HOME')}/.ssh:/home/jenkins/.ssh:rw"
]

docker_params = ["docker", "run", "--rm", "--init"]
print(f"__file__={__file__} argv={sys.argv}")
_args_ = sys.argv
_file = os.path.realpath(__file__)
for i in range(len(sys.argv)):
    par = os.path.realpath(sys.argv[i])
    if par == _file:
        _args_ = sys.argv[i+1:]
        break
extra_args = []
dockerfile = "Dockerfile"
if len(_args_) > 0:
    #docker_params.extend(["-t", "-it"])
    parser = argparse.ArgumentParser(_args_)
    parser.add_argument("-u", dest="user", default="jenkins", choices=["jenkins", "root"], help="user in container")
    parser.add_argument("-w", dest="workdir", default="/usr/local/build", type=str, help="workdir in container")
    parser.add_argument("-image", dest="image", default=default_image, help="docker image to run")
    parser.add_argument("-e", dest="environ", nargs="*", action="append", type=str, help="environment variable(s) VAR=VALUE")
    parser.add_argument("-E", dest="os_environ", nargs="*", action="append", type=str, help="translate os.environment variable(s) VAR")

    parser.add_argument("-v", dest="volumes", nargs="*", action="append", type=str, help="map volume(s)")
    parser.add_argument("-p", dest="ports", nargs="*", action="append", type=str, help="map port(s)")
    parser.add_argument("-f", dest="dockerfile", default=f"{dockerfile}", type=str, help="Dockerfile to use")


    args = parser.parse_known_args()
#    print(args)
#    print(args[0].user)
#    print(args[1])
    for arg in args[1]:
        if arg != "--":
            extra_args.append(arg)
            arg_sp = arg.split("/")
            if sys.stdout.isatty():
                docker_params.extend(["-t", "-it"])

    docker_params.append("-u")
    docker_params.append(args[0].user)
    docker_params.append("-w")
    docker_params.append(args[0].workdir)

    if args[0].environ:
        for env_ in args[0].environ:
            docker_params.append("-e")
            docker_params.append(env_[0])
    if args[0].os_environ:
        for env_ in args[0].os_environ:
            docker_params.append("-e")
            var = env_[0]
            val = os.environ.get(var, '')
            docker_params.append(f"{var}={val}")
    if args[0].volumes:
        for vol_ in args[0].volumes:
            docker_params.append("-v")
            docker_params.append(vol_[0])
    if args[0].ports:
        for port in args[0].ports:
            docker_params.append("-p")
            docker_params.append(port[0])
    default_image = args[0].image
    dockerfile = args[0].dockerfile

for k, v in env.items():
    docker_params.append("-e")
    docker_params.append(f"{k}={v}")

for v in volumes:
    docker_params.append("-v")
    docker_params.append(v)

docker_params.append(default_image)
docker_params.extend(extra_args)

if os.path.dirname(dockerfile) == "":
    dockerfile = os.path.join(os.path.dirname(__file__), dockerfile)

need_rebuild = True
dockerfile_sum = hashlib.md5(open(dockerfile, "r").read().encode()).hexdigest()

cmd = [ "docker", "images", default_image, "-q"]
out = subprocess.check_output(cmd).decode().split("\n")
if len(out)>1 and len(out[0]) == 12:
    cmd_inspect = f"docker image inspect {out[0]}".split(" ")
    inspect_data = json.loads(subprocess.check_output(cmd_inspect).decode())
    labels = inspect_data[0]['Config']['Labels']
    if labels:
        image_sum = labels.get("dockerfile_sum")
        print(f"Dockerfile hash={dockerfile_sum}, hash from image={image_sum}")
        if image_sum == dockerfile_sum:
            need_rebuild = False
            print("no need build docker image")

if need_rebuild:
    print("rebuild image")
    subprocess.run(["./ssh-keys.sh"], cwd=os.path.dirname(__file__), shell=True)
    r = subprocess.run(["docker", "build", "-f", dockerfile, "--label", f"dockerfile_sum={dockerfile_sum}", "--force-rm", "--rm", "-t", default_image,  "--build-arg", f"uid={os.getuid()}", "--build-arg", f"docker_gid={grp.getgrnam('docker').gr_gid}", os.path.dirname(__file__)])
    if r.returncode != 0:
        sys.exit(r.returncode)

print(" ".join(docker_params))

os.execvp("docker", docker_params)
