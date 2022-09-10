{ lib, pkgs, ... }:

{
  config = {
    home-manager.users.ana = ./home.nix;
    users.users.ana = {
      isNormalUser = true;
      home = "/home/ana";
      createHome = true;
      passwordFile = "/persist/encrypted-passwords/ana";
      extraGroups = [ "wheel" "disk" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVkA7kB9DDbjmU93LaGz7h2uco4hCJx7xT7OJ9YkoXzcFqIiXhBITx9s3+OJSlWkeJ51nShgZXTLgDPaW8uU1TS7vwqVwGbe35rSPCyAxjYzY7ZMKi3u9PTb73cI6CfmWg9uU5ox3g3dUF5xNm5CsKulCd/eXASYgaiEH8AQ8R1nrr4M7A92ZzxepzhETjCVYdz8fT4f35Pfs/Sn70h9uxfZ7SCbQ3jhGuWpEhgfEBwqRpqeMRSXUQwE88ThKn++iXfENVzPJKP4TT+bX36oHlH7c1Wex5e3uHd/elDbq3Q+h3b7T3QUlH5AdKk6SkHnPn6NSdHoU+gWiMDdeCipPdpJZAkJlTmACq62JcmT3trIbNi3Q92Oh+lvonaN17d6sAmNx5om82R84qrzPusom4YIIfLRekbPFzPDvdR8ZDJPaXM8jDv+JwMhMlM0Iqb2tXB9RQ0Gz1DJX45dEnVbjyIJGbYwUnwjzK1LaahKd9HKuLlloMaAfw3H4jnzOeiSU= ana@architect"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/+nG+yQbZREeShNJeyZcOpqT5YQ3tGNk8SWopT10qmv9+qynaVSwTvTeWj/i5l6EH/yrImt8rofFIh1e9x20Vs2iAkTozaTOPqgbw7n1gerUO5gXTdhLUbndrhZ0BYIOIZf1xCYOsLtzQdj9/RRZdZW+E60tuLU6QObcwFPTWIWKjA78j1sfl0ZF2iPBnKYAstU5KpX+h+rs8wGL56V98IKrmv4WWNAsmRnnrWSHsCdHcQT6R82b5ZgYjG7rd+2tCPYNVOIkAlJAOQcFCa2DNiCNpQGaKtJSTJtrHZZPfBHttbk+axK8QhIFNR/ULZQtW25uIS9ciP9bl9CsfbRymxf0oCdLNZAqunnvIdC5I4Dn9wmpaz5/4YUaGsmjXUxrY0zLsaENOk8qZ1W3L8IoeQwqCXU/87PWlE6d+ErrUEJhEK7a3mVckQeIdH+u97mLo76TJnrLAtA3OJCt9/m0/uEYeN4+z8g5ypXmRGPKHVb84dYj7LuTKKCA1NyvwE4k= ana@gizmo"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0x8dkJXgLqVjUaJd9v4ytXehk5Vx4Xb1OkVt6AEoCS92C8ExYaVBZeQt7bkxvjUA9iVjs6KLzA+5CTWfDz5aEy1WQ2Vnqr2g4qmfkGfvKDEVn6PHcxj62MLRMWpm9laNYpaRc2Cfn4Rtt4K/87aamHlk5r77+CUwI7bWwykmCPwftR+6ui5iwjvDn5/9gvhW/CBXzyzAvR530zm/G2GbCvqxT35kF9x+K/lBk6dXdrhvsSTB1QNX6envGiElTfRXN6B0ltiNYweccdtCTe8Is486aiqtkFow9NpawOce7x4RkNwxgRiyZBfLt48rBUvmTChhoIJNVezGelofuA+nHxA6aN0A+O43K78sXi18uFSuYZAPVp+E4mq7D2/vlddkDwKFn7hen+TEQzID3brXjRgmqzvZFQDmyKc4zOIYTzi0d5eV+AzDztpr83yd4jX+Z6UDfw/5MJvIK8WxauCKFnZyelrp0iAIuV2kyjlHA9njpscG6/VzGbF6mSdSMFEc= ana@autonoma"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoz2DLGGGkAWTB5MMoRzmvjM5sror8QB2GUfS2cAhvdGMkjtM9yF+NunxfjnxSWYpnSwYleT9b475P2h2+bW0wO25ew6AI1EPyXEsORIPgyU6t8jtVyUUCuo4/LTZw2dmaBHMISNMtnE3FULqq3zhVUFwfi53l6jn/+iuWW3yGcFk0OcsgcYFFGI0PWki2QYFerkJt0UETOqOHjPkOAs56zx/0UxFKxwn9mFF5vwF0Hd7O1e31PYVbTnNix/Xcji6JUjS/GfgsLou+mlQARvsjoJVBBe7qbTYIAXw9jQvchjAMYQZ/JJskiMPKeMU+ifNkga2maFxzrpucBLvQWQhxv47qBGbOvHPU4ePS2CM2Ll8/PRhWxR1a2y8DKUrlBT9I3baWkbXmPlHJLKZBlUhkiu+A2eXrTjdmVHtBECktanCmuVL4FBlS0JZMZrkIwtfRxTpRpdCLtHh6mj/xPmq0pqtGZaIutSFOqz+vV29pzT4w9sl7ob8n7QhpZUkmZz8= ana@nomad"
      ];
    };
  };
}
