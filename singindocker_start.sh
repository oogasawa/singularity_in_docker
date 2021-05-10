sudo docker run -it --privileged --name test_env02 \
  -v /home/oogasawa/data:/home/user01/data \
  -v /home/oogasawa/works:/home/user01/works \
  -v /home/oogasawa/public_html:/home/user01/public_html \
  oogasawa/singindocker:1.0.3 /bin/bash
