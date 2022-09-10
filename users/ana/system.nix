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
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdGj8zlIxR19zrbEsXsu4Gf5a2DYRLVSKuWuKeOgxyBvYbrHBm7jie6GH7SYsgdqI1ap3aRQ9d2GrszeS5FkJ08zp8sXI/Yxz+/rcyTFu/NV2XwJdK1xWedVF2+x2fo7RqP5kWB+V2ARX7a+6FMV38P5DCeUr8IIx2JsvRYJzJpk9u54tz22bO7qTBBaxFzFF2ZQ6PeUtqYqOmYrF/FrvDOUJqxJCJnxtKfyK96ccwUUtKfE/Pwit4GQvFsSop+gw4Cgpo2SwvXdl8YaZpb9A+MF/qw0mKtn10vqr5JdkCvQcygT1e6r3ZCnDPxXr3uGBlW1ehpC2q3nxoCjRsm4c5aRnBIHMygviZb2ZYBTZo6fBfaGHBsQR7ZzM2cY9oLVzB4NsWitcP5egRNMqplOjARYb/Tq2AF/KGIPXPJ5g6IbqsLXLatUTikP9vvY6heNSm7bpk9aeNtMbq+iKc99EoMndmgLu1wL93Syae/4SeWEAnCO5vlBtqWG9It9hQ8I0= ana@gizmo"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0x8dkJXgLqVjUaJd9v4ytXehk5Vx4Xb1OkVt6AEoCS92C8ExYaVBZeQt7bkxvjUA9iVjs6KLzA+5CTWfDz5aEy1WQ2Vnqr2g4qmfkGfvKDEVn6PHcxj62MLRMWpm9laNYpaRc2Cfn4Rtt4K/87aamHlk5r77+CUwI7bWwykmCPwftR+6ui5iwjvDn5/9gvhW/CBXzyzAvR530zm/G2GbCvqxT35kF9x+K/lBk6dXdrhvsSTB1QNX6envGiElTfRXN6B0ltiNYweccdtCTe8Is486aiqtkFow9NpawOce7x4RkNwxgRiyZBfLt48rBUvmTChhoIJNVezGelofuA+nHxA6aN0A+O43K78sXi18uFSuYZAPVp+E4mq7D2/vlddkDwKFn7hen+TEQzID3brXjRgmqzvZFQDmyKc4zOIYTzi0d5eV+AzDztpr83yd4jX+Z6UDfw/5MJvIK8WxauCKFnZyelrp0iAIuV2kyjlHA9njpscG6/VzGbF6mSdSMFEc= ana@autonoma"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmPdQtg3P5wTFdbye4+rYLV5zCCBIhNZKCirbf7J7QAYNwDx/m6PQr1bP/i1phdnWMSDsRFS/8KG7l32QvZG6vLbfm/o5KOhkM1CBJI2hki6bFZo9rsMu+XYDymzayz/MlLKkYi2qPI5jWI9U9dLnxbcLekF8tWIvZGN54XC7RPWznpsReMRGQco9Ko3XvKF8uEJ5O501EX8bcjkPd/iJLVSqQdu/xOnQNQJ+KVRE3DMRhZevAgagPs/YB8tLwSY86rP21kAlkqxgfEEmLkh2LAIEukf056TtCTnlhwLEw/gAf3rPFJLUmvePwQa0AaT+tQpmjcGaNa70oU3pEqWeK9IkhgDPqR1p2bP7JDoujYEnSdqkJT5M+WcKgqGDyFvVlnj4nYJabklFj4+UBJ53I2M6t/dLzXmthNGk1Sp2tF4ZfNUOFtbc1GJr2GtXu2eaXFAoRpbCFtubDbCVCsRgCM/Mk7CQk5Sovrq/sVt3XAEvSq/YCECWaOivNJXKvQV8= ana@nomad"
      ];
    };
  };
}
